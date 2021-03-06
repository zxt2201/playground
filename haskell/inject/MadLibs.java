package propertyfile.impl;

import com.google.inject.Inject;
import com.google.inject.name.Named;

public class MadLibs {
  private final String name;
  private final String verb;
  private final String noun;

  @Inject
  public MadLibs(@Named("nameOfPerson")String name, @Named("pastTenseVerb") String verb, @Named("noun")String noun) {
    this.name = name;
    this.verb = verb;
    this.noun = noun;
  }

  public String getJoke() {
    return "One day, " + name + " " + verb + " to New York to see the " + noun + ".";
  }

}
