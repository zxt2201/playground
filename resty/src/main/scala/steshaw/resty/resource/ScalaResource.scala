package steshaw.resty.resource

import javax.ws.rs.{GET, Produces, Path, PathParam}

@Path("scala")
class ScalaResource {
    @GET
    @Produces(Array("text/plain"))
    def helloScala = "RESTful hello from Scala!\n";

    @GET
    @Path("/java")
    def java = "Hello. " + steshaw.resty.resource.JavaResource.message + "\n"

    @GET
    @Path("user/{id}")
    @Produces(Array("text/plain"))
    def blah(@PathParam("id") id:String) = "Hello " + id + ".\n"
}

object ScalaResource {
  val message = "Scala rocks!"
}
