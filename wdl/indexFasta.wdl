version 1.0

# index fa file

workflow indexFasta {
    meta {
        author: "Mira Mastoras"
        email: "mmastora@ucsc.edu"
        description: "Index Fasta with samtools "
    }
    call Index
    output {
        File outFai = Index.outFai
    }
}

task Index{
    input {
        File fasta

        String dockerImage = "kishwars/pepper_deepvariant:r0.8"
        Int memSizeGB = 128
        Int threadCount = 64
        Int diskSizeGB = 128
    }

    command <<<
        # exit when a command fails, fail with unset variables, print commands before execution
        set -eux -o pipefail
        set -o xtrace

        FILENAME=$(basename -- "~{fasta}")
        SUFFIX="${FILENAME##*.}"

        if [[ "$SUFFIX" == "gz" ]] ; then
            ID=`basename ~{fasta} | sed 's/.gz$//'`
            gunzip -c ~{fasta} > ${ID}
        else
            ID=$FILENAME
            ln -s ~{fasta} ./$ID
        fi
        samtools faidx ${ID}
    >>>
    output {
        File outFai = glob("*.fai")[0]
    }
    runtime {
        memory: memSizeGB + " GB"
        cpu: threadCount
        disks: "local-disk " + diskSizeGB + " SSD"
        docker: dockerImage
    }
}
