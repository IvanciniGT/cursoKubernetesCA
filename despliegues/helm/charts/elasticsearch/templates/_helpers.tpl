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

{{- define "elasticsearch.imageold" -}}
image: {{ .Values.elasticsearch.image.repo }}:{{ if .Values.elasticsearch.image.tag -}} 
{{- .Values.elasticsearch.image.tag -}} 
{{- else -}}
{{- .Chart.AppVersion -}} 
{{- end -}}
{{- end -}}

{{- define "elasticsearch.image" -}}
image: {{ .Values.elasticsearch.image.repo }}:{{ .Values.elasticsearch.image.tag | default .Chart.AppVersion  -}} 
{{- end -}}
{{/* image: {{ .Values.elasticsearch.image.repo }}:{{ default .Chart.AppVersion .Values.elasticsearch.image.tag -}} */}}
