//ftl:module checkout
package checkout

import (
	"context"
	"fmt"

	"github.com/TBD54566975/ftl/examples/online-boutique/slices"

	"github.com/google/uuid"

	"ftl/builtin"
	"ftl/cart"
	"ftl/currency"
	"ftl/payment"
	"ftl/productcatalog"
	"ftl/shipping"

	"github.com/TBD54566975/ftl/examples/online-boutique/common/money"

	"github.com/TBD54566975/ftl/go-runtime/ftl"
)

type PlaceOrderRequest struct {
	UserID       string
	UserCurrency string

	Address    shipping.Address
	Email      string
	CreditCard payment.CreditCardInfo
}

type OrderItem struct {
	Item cart.Item
	Cost currency.Money
}

type Order struct {
	ID                 string
	ShippingTrackingID string
	ShippingCost       currency.Money
	ShippingAddress    shipping.Address
	Items              []OrderItem
}

type ErrorResponse struct {
	Message string `json:"message"`
}

//ftl:ingress POST /checkout/{userId}
func PlaceOrder(ctx context.Context, req builtin.HttpRequest[PlaceOrderRequest]) (builtin.HttpResponse[Order, ErrorResponse], error) {
	logger := ftl.LoggerFromContext(ctx)

	cartItemsResp, err := ftl.Call(ctx, cart.GetCart, builtin.HttpRequest[cart.GetCartRequest]{Body: cart.GetCartRequest{UserId: req.Body.UserID}})
	if err != nil {
		return builtin.HttpResponse[Order, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to get cart for user %q: %w", req.Body.UserID, err)}),
		}, nil
	}

	cartItems, ok := cartItemsResp.Body.Get()
	if !ok {
		return builtin.HttpResponse[Order, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to get cart for user %q %s", req.Body.UserID, cartItemsResp.Error.MustGet())}),
		}, nil
	}

	orders := make([]OrderItem, len(cartItems.Items))
	for i, item := range cartItems.Items {
		productsResp, err := ftl.Call(ctx, productcatalog.Get, builtin.HttpRequest[productcatalog.GetRequest]{Body: productcatalog.GetRequest{Id: item.ProductId}})
		if err != nil {
			return builtin.HttpResponse[Order, ErrorResponse]{
				Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to get product #%q: %w", item.ProductId, err)}),
			}, nil
		}

		products, ok := productsResp.Body.Get()
		if !ok {
			return builtin.HttpResponse[Order, ErrorResponse]{
				Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("product not found: %q %s", item.ProductId, productsResp.Error.MustGet())}),
			}, nil
		}

		priceResp, err := ftl.Call(ctx, currency.Convert, builtin.HttpRequest[currency.ConvertRequest]{
			Body: currency.ConvertRequest{
				From:   products.PriceUsd,
				ToCode: req.Body.UserCurrency,
			},
		})
		if err != nil {
			return builtin.HttpResponse[Order, ErrorResponse]{
				Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to convert price of %q to %s: %w", item.ProductId, req.Body.UserCurrency, err)}),
			}, nil
		}

		price, ok := priceResp.Body.Get()
		if !ok {
			return builtin.HttpResponse[Order, ErrorResponse]{
				Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to convert price of %q to %s %s", item.ProductId, req.Body.UserCurrency, priceResp.Error.MustGet())}),
			}, nil
		}

		orders[i] = OrderItem{
			Item: item,
			Cost: price,
		}
	}

	shippingUSDResp, err := ftl.Call(ctx, shipping.GetQuote, builtin.HttpRequest[shipping.ShippingRequest]{
		Body: shipping.ShippingRequest{
			Address: req.Body.Address,
			Items:   slices.Map(orders, func(i OrderItem) cart.Item { return i.Item }),
		},
	})
	if err != nil {
		return builtin.HttpResponse[Order, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to get shipping quote: %w", err)}),
		}, nil
	}

	shippingUSD, ok := shippingUSDResp.Body.Get()
	if !ok {
		return builtin.HttpResponse[Order, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to get shipping quote %s", shippingUSDResp.Error.MustGet())}),
		}, nil
	}

	shippingPriceResp, err := ftl.Call(ctx, currency.Convert, builtin.HttpRequest[currency.ConvertRequest]{
		Body: currency.ConvertRequest{
			From:   shippingUSD,
			ToCode: req.Body.UserCurrency,
		},
	})
	if err != nil {
		return builtin.HttpResponse[Order, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to convert shipping cost to currency: %v", err)}),
		}, nil
	}

	shippingPrice, ok := shippingPriceResp.Body.Get()
	if !ok {
		return builtin.HttpResponse[Order, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to convert shipping cost to currency %s", shippingPriceResp.Error.MustGet())}),
		}, nil
	}

	total := currency.Money{CurrencyCode: req.Body.UserCurrency}
	total = money.Must(money.Sum(total, shippingPrice))
	for _, it := range orders {
		multPrice := money.MultiplySlow(it.Cost, uint32(it.Item.Quantity))
		total = money.Must(money.Sum(total, multPrice))
	}
	txIDResp, err := ftl.Call(ctx, payment.Charge, builtin.HttpRequest[payment.ChargeRequest]{
		Body: payment.ChargeRequest{
			Amount:     total,
			CreditCard: req.Body.CreditCard,
		},
	})
	if err != nil {
		return builtin.HttpResponse[Order, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to charge card: %w", err)}),
		}, nil
	}

	txID, ok := txIDResp.Body.Get()
	if !ok {
		return builtin.HttpResponse[Order, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to charge card %v", txIDResp.Error.MustGet())}),
		}, nil
	}

	logger.Infof("Charged card, ID %s", txID.TransactionId)

	shippingTrackingIDResp, err := ftl.Call(ctx, shipping.ShipOrder, builtin.HttpRequest[shipping.ShippingRequest]{
		Body: shipping.ShippingRequest{
			Address: req.Body.Address,
			Items:   cartItems.Items,
		},
	})
	if err != nil {
		return builtin.HttpResponse[Order, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("shipping error: %w", err)}),
		}, nil
	}

	shippingTrackingID, ok := shippingTrackingIDResp.Body.Get()
	if !ok {
		return builtin.HttpResponse[Order, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{Message: fmt.Sprintf("failed to ship order %s", shippingTrackingIDResp.Error.MustGet())}),
		}, nil
	}

	logger.Infof("Shipped order, tracking ID %s", shippingTrackingID.Id)

	// Empty the cart, but don't worry about errors.
	_, _ = ftl.Call(ctx, cart.EmptyCart, builtin.HttpRequest[cart.EmptyCartRequest]{Body: cart.EmptyCartRequest{UserId: req.Body.UserID}})

	order := Order{
		ID:                 uuid.New().String(),
		ShippingTrackingID: shippingTrackingID.Id,
		ShippingCost:       shippingPrice,
		ShippingAddress:    req.Body.Address,
		Items:              orders,
	}
	// if err := s.emailService.Get().SendOrderConfirmation(ctx, req.Email, order); err != nil {
	// 	s.Logger(ctx).Error("failed to send order confirmation", "err", err, "email", req.Email)
	// } else {
	// 	s.Logger(ctx).Info("order confirmation email sent", "email", req.Email)
	// }

	return builtin.HttpResponse[Order, ErrorResponse]{Body: ftl.Some(order)}, nil
}
