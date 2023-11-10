// ignore_for_file: unused_import
library {{ .Name | lower }};

import 'dart:convert';
import 'ftl_client.dart';
{{- range .Imports}}
import '{{. | lower }}.dart' as {{. | lower}};
{{- end}}

{{- define "darttype" -}}
{{- $type := (. | typename ) -}}
{{- if eq $type "Array" }}List<{{ template "darttype" .Element }}>
{{- else if eq $type "Map" }}Map<{{ template "darttype" .Key }}, {{ template "darttype" .Value }}>
{{- else if eq $type "DataRef" }}{{ . }}
{{- else if eq $type "Int" }}int
{{- else if eq $type "Bool" }}bool
{{- else if eq $type "Float" }}double
{{- else if eq $type "Time" }}DateTime
{{- else -}}{{ . | typename }}{{- end -}}
{{- end }}

{{- define "deserialize" -}}
{{- $type := (. | typename ) -}}
{{- if eq $type "Array" -}}
v.map((v) => {{ template "deserialize" .Element }}).cast<{{ template "darttype" .Element }}>().toList()
{{- else if eq $type "Map" -}}
v.map((k, v) => MapEntry(k, {{ template "deserialize" .Value }})).cast<{{ template "darttype" .Key }}, {{ template "darttype" .Value }}>()
{{- else if eq $type "DataRef" -}}
{{ . }}.fromMap(v)
{{- else -}}
v
{{- end }}
{{- end }}

{{- define "serialize" -}}
{{- $type := (. | typename ) -}}
{{- if eq $type "Array" -}}
v.map((v) => {{ template "deserialize" .Element }}).cast<{{ template "darttype" .Element }}>().toList()
{{- else if eq $type "Map" -}}
v.map((k, v) => MapEntry(k, {{ template "deserialize" .Value }})).cast<{{ template "darttype" .Key }}, {{ template "darttype" .Value }}>()
{{- else if eq $type "DataRef" -}}
v.toMap()
{{- else -}}
v
{{- end }}
{{- end }}

{{ range .Data }}
class {{ .Name | camel }} {
{{- range .Fields }}
  {{ template "darttype" .Type }} {{ .Name }};
{{- end }}

  {{ .Name | camel }}({{ if .Fields }}{ {{ range .Fields }}required this.{{ .Name }}, {{ end}} }{{ end }});

  Map<String, dynamic> toMap() {
    return {
{{- range .Fields}}
      '{{ .Name }}': ((dynamic v) =>{{ template "serialize" .Type }})({{ .Name }}),
{{- end }}
    };
  }

  factory {{ .Name | camel }}.fromMap(Map<String, dynamic> map) {
    return {{ .Name | camel }}(
{{- range .Fields }}
      {{ .Name }}: ((dynamic v) => {{ template "deserialize" .Type }})(map['{{ .Name }}']),
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
{{ if eq "MetadataIngress" (. | typename) }}
  Future<{{ $verb.Response }}> {{ $verb.Name }}({{ $verb.Request }} request) async {
    final response = await ftlClient.{{ .Method | lower }}('{{ .Path }}', request: request.toMap());
    if (response.statusCode == 200) {
      return {{ $verb.Response }}.fromJson(response.body);
    } else {
      throw Exception('Failed to get {{ $verb.Name }} response');
    }
  }
{{- end }}
{{- end }}
{{- end }}
}
