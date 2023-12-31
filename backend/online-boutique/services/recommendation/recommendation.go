//ftl:module recommendation
package recommendation

import (
	"context"
	"math/rand"

	"github.com/alecthomas/errors"

	"github.com/TBD54566975/ftl/examples/online-boutique/services/productcatalog"
	ftl "github.com/TBD54566975/ftl/go-runtime/sdk"
)

type ListRequest struct {
	UserID         string
	UserProductIDs []string
}

type ListResponse struct {
	ProductIDs []string
}

//ftl:verb
//ftl:ingress GET /recommendation
func List(ctx context.Context, req ListRequest) (ListResponse, error) {

	catalog, err := ftl.Call(ctx, productcatalog.List, productcatalog.ListRequest{})
	if err != nil {
		return ListResponse{}, errors.Wrap(err, "failed to retrieve product catalog")
	}

	// Remove user-provided products from the catalog, to avoid recommending
	// them.
	userIDs := make(map[string]struct{}, len(req.UserProductIDs))
	for _, id := range req.UserProductIDs {
		userIDs[id] = struct{}{}
	}
	filtered := make([]string, 0, len(catalog.Products))
	for _, product := range catalog.Products {
		if _, ok := userIDs[product.ID]; ok {
			continue
		}
		filtered = append(filtered, product.ID)
	}

	// Sample from filtered products and return them.
	perm := rand.Perm(len(filtered))
	const maxResponses = 5
	ret := make([]string, 0, maxResponses)
	for _, idx := range perm {
		ret = append(ret, filtered[idx])
		if len(ret) >= maxResponses {
			break
		}
	}
	return ListResponse{ProductIDs: ret}, nil

}
