{
  description = "A collection of flake templates";

  outputs = {self}: {
    templates = {
      scala = {
        path = ./scala;
        description = "A scala development flake";
      };

      python-cli = {
        path = ./python-cli;
        description = "A python cli development flake using click";
      };
    };
  };
}
