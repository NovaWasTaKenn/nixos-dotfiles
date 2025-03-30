{
  description = "A collection of flake templates";

  outputs = {self}: {
    templates = {
      scala = {
        path = ./scala;
        description = "A scala development flake";
      };

      defaultTemplate = self.templates.trivial;
    };
  };
}
