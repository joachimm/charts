#!/usr/bin/env sh
set -x
set -e

sleepTime="{{ .Values.images.updateIntervalInSecond }}"
images="
{{- range .Values.matchbox.groups }}
{{- if .metadata }}
{{- if .metadata.dockerImage }}
{{ .metadata.dockerImage }}
{{- end }}
{{- end }}
{{- end }}
"

dockerd &

sleep 15

while true; do
    for image in $(echo ${images} | sort | uniq); do
        if echo ${image} | grep -q -v ":"; then
            image="${image}:latest"
        fi
        imageName=${image%%:*}
        imageCleanup=$(echo $image | tr '(/|:)' '_')

        docker pull ${image}
        id=$(docker inspect --format="{{"{{"}}.Id{{"}}"}}" ${image} | cut -f2 -d:)
        currentId=$(readlink ${imageCleanup}.tar.gz | sed "s/${imageCleanup}-\(.*\).tar.gz/\1/")

        if [ ! -f "${imageCleanup}.tar.gz" ] || [ "$currentId" != "$id" ]; then
            echo "Updating to new version ${imageName}:${id}"
            imageDate=$(docker inspect --format '{{"{{"}} index .Config.Labels "date"{{"}}"}}' ${id})
            cid=$(docker run --rm -d --entrypoint=/bin/sh ${image} -c "echo 'IMAGE_HASH=\"${imageName}:${id}\"' >> /install.env; echo 'IMAGE_DATE=\"${imageDate}\"' >> /install.env; rm /.dockerenv; sleep 120")
            sleep 2
            docker export ${cid} | gzip -c > ${imageCleanup}-${id}.tar.gz
            old=$(readlink ${imageCleanup}.tar.gz) || true
            rm ${imageCleanup}.tar.gz || true
            ln -s ${imageCleanup}-${id}.tar.gz ${imageCleanup}.tar.gz
            rm -f "${old}"
        fi
    done
    sleep ${sleepTime}
done
 