#! /bin/bash

export PATH=$PATH:/usr/local/bin

getStatus() {
    docker ps --format "table {{.ID}}|{{.Names}}|{{.Size}}|{{.Status}}" | grep -v CONTAINER
}

restart() {
    docker container restart $1
}

shell() {
    osascript -e 'tell application "Terminal" to do script "docker exec -it '$1' sh"'
}

kill() {
    docker stop $(docker ps -a -q)
}

pstorm() {
    /usr/local/bin/pstorm "/Users/pablo/Sites/GitRepos/$(docker ps --format "table {{.Names}}" | grep "webserver" | cut -d_ -f 1)"
}

terminal() {
    REPO="$(docker ps --format 'table {{.Names}}' | grep webserver | cut -d_ -f 1)"
    REPO="/Users/pablo/Sites/GitRepos/${REPO}"
    osascript -e 'tell application "Terminal" to do script "cd '${REPO}'"'
}

"$@"
