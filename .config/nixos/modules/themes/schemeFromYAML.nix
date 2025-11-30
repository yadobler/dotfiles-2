# https://github.com/Misterio77/nix-colors/blob/main/lib/core/schemeFromYAML.nix

let
  inherit (builtins)
  elemAt filter listToAttrs substring replaceStrings stringLength genList;

  # All of these are borrowed from nixpkgs
  mapListToAttrs = f: l: listToAttrs (map f l);
  escapeRegex = escape (stringToCharacters "\\[{()^$?*+|.");
  addContextFrom = a: b: substring 0 0 a + b;
  escape = list: replaceStrings list (map (c: "\\${c}") list);
  range = first: last:
    if first > last then [ ] else genList (n: first + n) (last - first + 1);
  stringToCharacters = s:
    map (p: substring p 1 s) (range 0 (stringLength s - 1));
  splitString = _sep: _s:
    let
      sep = builtins.unsafeDiscardStringContext _sep;
      s = builtins.unsafeDiscardStringContext _s;
      splits = filter builtins.isString (builtins.split (escapeRegex sep) s);
    in
      map (v: addContextFrom _sep (addContextFrom _s v)) splits;
  nameValuePair = name: value: { inherit name value; };

  # Helper to clean hex codes
  removeHash = s: replaceStrings ["#"] [""] s;

  # From https://github.com/arcnmx/nixexprs
  fromYAML = yaml:
    let
      # Just check if it's empty or a full-line comment
      usefulLine = line: 
        (builtins.match "[ \\t]*" line == null) && 
        (builtins.match "[ \\t]*#.*" line == null);

        parseString = token:
        # Matches either an unquoted string (no spaces) OR a quoted string
        let match = builtins.match ''([^"]+|"([^"]*)" *)'' token;
        in if match == null then
        throw ''YAML string parse failed: "${token}"''
        else if elemAt match 1 != null then
        elemAt match 1
        else
        elemAt match 0;

        attrLine = line:
        # Regex to capture Key and Value, ignoring leading indentation
        let match = builtins.match "[ \\t]*([^ :]+): *(.*)" line;
        in if match == null then
          null 
        else
          let 
            key = elemAt match 0;
            val = elemAt match 1;
          in 
            # Skip lines that have a key but no value (like "palette:")
            if val == "" then null 
          else nameValuePair key (parseString val);

      lines = splitString "\n" yaml;
      lines' = filter usefulLine lines;

      parsedLines = map attrLine lines';
      validLines = filter (x: x != null) parsedLines;
    in
      listToAttrs validLines;

  convertScheme = slug: set: {
    name = set.name or set.scheme;
    inherit (set) author;
    inherit slug;
    palette = {
      base00 = removeHash set.base00;
      base01 = removeHash set.base01;
      base02 = removeHash set.base02;
      base03 = removeHash set.base03;
      base04 = removeHash set.base04;
      base05 = removeHash set.base05;
      base06 = removeHash set.base06;
      base07 = removeHash set.base07;
      base08 = removeHash set.base08;
      base09 = removeHash set.base09;
      base0A = removeHash set.base0A;
      base0B = removeHash set.base0B;
      base0C = removeHash set.base0C;
      base0D = removeHash set.base0D;
      base0E = removeHash set.base0E;
      base0F = removeHash set.base0F;
    };
  };

  schemeFromYAML = slug: content: convertScheme slug (fromYAML content);
in
  schemeFromYAML
