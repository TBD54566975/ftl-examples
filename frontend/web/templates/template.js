// Return the corresponding Typescript type for an FTL type.
function tsType(t) {
    const type = typeName(t);
    switch (type) {
      case "String":
        return "string";
  
      case "Int":
        return "number";
  
      case "Bool":
        return "bool";
  
      case "Float":
        return "double";
  
      case "Time":
        return "DateTime";
  
      case "Map":
        return `Map<${tsType(t.key)}, ${tsType(t.value)}>`;
  
      case "Array":
        return `${tsType(t.element)}[]`;
  
      case "VerbRef":
      case "DataRef":
        if (context.name === t.module) {
          return t.name;
        }
        return `${t.module}.${t.name}`;
  
      case "Optional":
        return tsType(t.type) + "?";
  
      default:
        throw new Error(`Unspported FTL type: ${typeName(t)}`);
    }
  }
  
  function deserialize(t) {
    switch (typeName(t)) {
      case "Array":
        return `v.map((v) => ${deserialize(t.element)}).cast<${tsType(t.element)}>().toList()`;
  
      case "Map":
        return `v.map((k, v) => MapEntry(k, ${deserialize(t.value)})).cast<${tsType(t.key)}, ${tsType(t.value)}>()`;
  
      case "DataRef":
        return `${tsType(t)}.fromMap(v)`;
  
      default:
        return "v";
    }
  }
  
  function serialize(t) {
    switch (typeName(t)) {
      case "Array":
        return `v.map((v) => ${deserialize(t.element)}).cast<${tsType(t.element)}>().toList()`;
  
      case "Map":
        return `v.map((k, v) => MapEntry(k, ${deserialize(t.value)})).cast<${tsType(t.key)}, ${tsType(t.value)}>()`;
  
      case "DataRef":
        return "v.toMap()";
  
      default:
        return "v";
    }
  }
  
  function url(verb) {
    let path = verb.metadata[0].path;
    const method = verb.metadata[0].method;
    
    path = path.replace(/{(.*?)}/g, (match, fieldName) => {
      return '$' + `{request.${fieldName}}`;
    });

    return method !== 'GET' ? path : path + '?@json=${encodeURIComponent(JSON.stringify(request))}';
  }
