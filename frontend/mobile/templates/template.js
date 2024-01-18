// Return the corresponding Dart type for an FTL type.
function dartType(t) {
  const type = typename(t);
  switch (type) {
    case "String":
      return "String";

    case "Int":
      return "int";

    case "Bool":
      return "bool";

    case "Float":
      return "double";

    case "Time":
      return "DateTime";

    case "Map":
      return `Map<${dartType(t.key)}, ${dartType(t.value)}>`;

    case "Array":
      return `List<${dartType(t.element)}>`;
    
    case "Bytes":
      return `Uint8List`;

    case "VerbRef":
    case "DataRef":
      if (context.name === t.module) {
        return t.name;
      }
      return `${t.module}.${t.name}`;

    case "Optional":
      return dartType(t.type) + "?";

    default:
      throw new Error(`Unspported FTL type: ${typename(t)}`);
  }
}

function deserialize(t) {
  switch (typename(t)) {
    case "Array":
      return `v.map((v) => ${deserialize(t.element)}).cast<${dartType(t.element)}>().toList()`;

    case "Map":
      return `v.map((k, v) => MapEntry(k, ${deserialize(t.value)})).cast<${dartType(t.key)}, ${dartType(t.value)}>()`;

    case "DataRef":
      return `${dartType(t)}.fromMap(v)`;

    default:
      return "v";
  }
}

function serialize(t) {
  switch (typename(t)) {
    case "Array":
      return `v.map((v) => ${serialize(t.element)}).cast<${dartType(t.element)}>().toList()`;

    case "Map":
      return `v.map((k, v) => MapEntry(k, ${serialize(t.value)})).cast<${dartType(t.key)}, ${dartType(t.value)}>()`;

    case "DataRef":
      return "v.toMap()";

    default:
      return "v";
  }
}

function url(verb) {
  let path = '/' + verb.metadata[0].path.join("/");

  return path.replace(/{(.*?)}/g, (match, fieldName) => {
    return "$" + `{request.${fieldName}}`;
  });
}
