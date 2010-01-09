package steshaw.resty;

import javax.ws.rs.GET;
import javax.ws.rs.Produces;
import javax.ws.rs.Path;

@Path("greeting")
public class SimpleResource {

    @GET
    @Produces("text/plain")
    public String getGreeting() {
        return "Hi there\n";
    }

}
