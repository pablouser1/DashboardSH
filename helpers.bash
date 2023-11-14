helpers_source_dir() {
    local path=$1

    for f in $(find $path -type f -name "*.bash"); do
        source $f
    done
}
