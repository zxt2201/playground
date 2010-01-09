package steshaw.resty.resource

import javax.ws.rs.GET
import javax.ws.rs.Produces
import javax.ws.rs.Path

@Path("scala")
class ScalaResource {

    @GET
    @Produces(Array("text/plain"))
    def helloScala(): String = "RESTful hello from Scala!\n";

}
