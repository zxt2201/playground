package steshaw.resty.resource;

import javax.ws.rs.GET;
import javax.ws.rs.Produces;
import javax.ws.rs.Path;

@Path("hello")
public class HelloResource {

    @GET 
    @Produces("text/plain")
    public String hello() {
        return "Hello!\n";
    }

}
