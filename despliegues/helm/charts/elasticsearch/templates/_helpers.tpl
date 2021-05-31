{{- define "elasticsearch.masterservicename" -}}
    {{- $contextoservicio := .Values.elasticsearch.master.service -}}
    {{- $contexto := merge $contextoservicio .Release }}
    {{- include "elasticsearch.servicename" $contexto -}}
{{- end -}}

{{- define "elasticsearch.servicename" -}}
    {{- if .customName -}}    
    {{- .customName -}}
    {{- else -}}
    {{- .Name }}-{{ .customSuffix -}}
    {{- end -}}
{{- end -}}
