// ignore_for_file: unused_import
library {{ .Name | lower }};

import 'dart:convert';
import 'ftl_client.dart';
{{- range .Imports }}
import '{{. | lower }}.dart' as {{. | lower}};
{{- end}}

{{ range .Data }}
class {{ .Name | camel }} {
{{- range .Fields }}
  {{ .Type | dartType }} {{ .Name }};
{{- end }}

  {{ .Name | camel }}({{ if .Fields }}{ {{ range .Fields }}{{ if not (eq (.Type | typeName) "Optional")}} required{{end}} this.{{ .Name }}, {{ end}} }{{ end }});

  Map<String, dynamic> toMap() {
    return {
{{- range .Fields}}
      '{{ .Name }}': ((dynamic v) => {{ .Type | serialize }})({{ .Name }}),
{{- end }}
    };
  }

  factory {{ .Name | camel }}.fromMap(Map<String, dynamic> map) {
    return {{ .Name | camel }}(
{{- range .Fields }}
      {{ .Name }}: ((dynamic v) => {{ .Type | deserialize }})(map['{{ .Name }}']),
{{- end }}
    );
  }

  String toJson() => json.encode(toMap());

  factory {{ .Name | camel }}.fromJson(String source) => {{ .Name | camel }}.fromMap(json.decode(source));
}
{{ end}}

class {{ .Name | camel }}Client {
  final FTLHttpClient ftlClient;

  {{ .Name | camel }}Client({required this.ftlClient});
{{ range .Verbs }}
{{- $verb := . -}}
{{- range .Metadata }}
{{ if eq "MetadataIngress" (. | typeName) }}
  Future<{{ $verb.Response | dartType }}> {{ $verb.Name }}({{ $verb.Request | dartType }} request) async {
    {{ if eq .Method "GET" -}}
    final response = await ftlClient.{{ .Method | lower }}('{{ $verb | url }}', requestJson: request.toJson());
    {{ else -}}
    final response = await ftlClient.{{ .Method | lower }}('{{ $verb | url }}', request: request.toMap());
    {{ end -}}
    if (response.statusCode == 200) {
      return {{ $verb.Response | dartType }}.fromJson(response.body);
    } else {
      throw Exception('Failed to get {{ $verb.Name }} response');
    }
  }
{{- end }}
{{- end }}
{{- end }}
}
