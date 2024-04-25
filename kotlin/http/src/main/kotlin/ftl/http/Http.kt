package ftl.http

import ftl.builtin.Empty
import ftl.builtin.HttpRequest
import ftl.builtin.HttpResponse
import xyz.block.ftl.*
import kotlin.String

data class GetRequest(
    @Json("userId") val userID: String,
    @Json("postId") val postID: String,
)

data class Nested(
    @Json("good_stuff") val goodStuff: String,
)

data class GetResponse(
    @Json("msg") val message: String,
    @Json("nested") val nested: Nested,
)

data class PostRequest(
    @Json("user_id") val userId: Int,
    @Json("post_id") val postId: Int,
)

data class PostResponse(
    @Json("success") val success: Boolean,
)

data class PutRequest(
    @Json("userId") val userID: String,
    @Json("postId") val postID: String,
)

data class DeleteRequest(
    @Json("userId") val userID: String,
)

// Example:       curl -i http://localhost:8892/ingress/http/users/123/posts?postId=456
// Error Example: curl -i http://localhost:8892/ingress/http/users/000/posts?postId=456
@Export(Visibility.PUBLIC, Ingress.HTTP, Method.GET, "/http/users/{userId}/posts")
fun `get`(context: Context, req: HttpRequest<GetRequest>): HttpResponse<GetResponse, String> {
    return HttpResponse(
        status = 200,
        headers = mapOf("Get" to arrayListOf("Header from FTL")),
        body = GetResponse(
            message = "UserID: ${req.body.userID}, PostID: ${req.body.postID}",
            nested = Nested(goodStuff = "This is good stuff")
        )
    )
}

// Example: curl -i --json '{"user_id": 123, "post_id": 345}' http://localhost:8892/ingress/http/users
@Export(Visibility.PUBLIC, Ingress.HTTP, Method.POST, "/http/users")
fun post(context: Context, req: HttpRequest<PostRequest>): HttpResponse<PostResponse, String> {
    return HttpResponse(
        status = 201,
        headers = mapOf("Post" to arrayListOf("Header from FTL")),
        body = PostResponse(success = true)
    )
}

// Example: curl -X PUT http://localhost:8892/ingress/http/users/123 -d '{"postId": "123"}'
@Export(Visibility.PUBLIC, Ingress.HTTP, Method.PUT, "/http/users/{userId}")
fun put(context: Context, req: HttpRequest<PutRequest>): HttpResponse<Empty, String> {
    return HttpResponse(
        status = 200,
        headers = mapOf("Put" to arrayListOf("Header from FTL")),
        body = Empty()
    )
}

// Example: curl -X DELETE http://localhost:8892/ingress/http/users/123
@Export(Visibility.PUBLIC, Ingress.HTTP, Method.DELETE, "/http/users/{userId}")
fun delete(context: Context, req: HttpRequest<DeleteRequest>): HttpResponse<Empty, String> {
    return HttpResponse(
        status = 200,
        headers = mapOf("Delete" to arrayListOf("Header from FTL")),
        body = Empty()
    )
}
