//ftl:module http
package http

import (
	"context"
	"fmt"

	"ftl/builtin" // Import the FTL built-in package.

	"github.com/TBD54566975/ftl/go-runtime/ftl" // Import the FTL SDK.
)

type GetRequest struct {
	UserID string `json:"userId"`
	PostID string `json:"postId"`
}

type Nested struct {
	GoodStuff string `json:"good_stuff,omitempty"`
}

type GetResponse struct {
	Message string `json:"msg"`
	Nested  Nested `json:"nested"`
}

type ErrorResponse struct {
	Error string `json:"error"`
}

// Example:       curl -i http://localhost:8892/ingress/http/users/123/posts?postId=456
// Error Example: curl -i http://localhost:8892/ingress/http/users/000/posts?postId=456
//
//ftl:export
//ftl:ingress http GET /http/users/{userId}/posts
func Get(ctx context.Context, req builtin.HttpRequest[GetRequest]) (builtin.HttpResponse[GetResponse, ErrorResponse], error) {
	if req.Body.UserID == "000" {
		return builtin.HttpResponse[GetResponse, ErrorResponse]{
			Error: ftl.Some(ErrorResponse{
				Error: "User not found",
			}),
		}, nil
	}

	return builtin.HttpResponse[GetResponse, ErrorResponse]{
		Headers: map[string][]string{"Get": {"Header from FTL"}},
		Body: ftl.Some(GetResponse{
			Message: fmt.Sprintf("Got userId %s and postId %s", req.Body.UserID, req.Body.PostID),
			Nested:  Nested{GoodStuff: "Nested Good Stuff"},
		}),
	}, nil
}

type PostRequest struct {
	UserID int `json:"user_id"`
	PostID int `json:"post_id"`
}

type PostResponse struct {
	Success bool `json:"success"`
}

// Example: curl -i --json '{"user_id": 123, "post_id": 345}' http://localhost:8892/ingress/http/users
//
//ftl:export
//ftl:ingress http POST /http/users
func Post(ctx context.Context, req builtin.HttpRequest[PostRequest]) (builtin.HttpResponse[PostResponse, ftl.Unit], error) {
	return builtin.HttpResponse[PostResponse, ftl.Unit]{
		Status:  201,
		Headers: map[string][]string{"Post": {"Header from FTL"}},
		Body:    ftl.Some(PostResponse{Success: true}),
	}, nil
}

type PutRequest struct {
	UserID string `json:"userId,omitempty"`
	PostID string `json:"postId"`
}

type PutResponse struct{}

// Example: curl -X PUT http://localhost:8892/ingress/http/users/123 -d '{"postId": "123"}'
//
//ftl:export
//ftl:ingress http PUT /http/users/{userId}
func Put(ctx context.Context, req builtin.HttpRequest[PutRequest]) (builtin.HttpResponse[PutResponse, ftl.Unit], error) {
	return builtin.HttpResponse[PutResponse, ftl.Unit]{
		Headers: map[string][]string{"Put": {"Header from FTL"}},
		Body:    ftl.Some(PutResponse{}),
	}, nil
}

type DeleteRequest struct {
	UserID string `json:"userId"`
}

type DeleteResponse struct{}

// Example: curl -X DELETE http://localhost:8892/ingress/http/users/123
//
//ftl:export
//ftl:ingress http DELETE /http/users/{userId}
func Delete(ctx context.Context, req builtin.HttpRequest[DeleteRequest]) (builtin.HttpResponse[DeleteResponse, ftl.Unit], error) {
	return builtin.HttpResponse[DeleteResponse, ftl.Unit]{
		Headers: map[string][]string{"Delete": {"Header from FTL"}},
		Body:    ftl.Some(DeleteResponse{}),
	}, nil
}
