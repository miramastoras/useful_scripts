version 1.0

# index fa file

workflow indexFasta {
    meta {
        author: "Mira Mastoras"
        email: "mmastora@ucsc.edu"
        description: "unzip gzipped fasta, index it"
    }
    call Index
    output {
        File outFai = Index.outFai
        File outFasta = Index.outFasta
    }
}

task Index{
    input {
        File fastaGZ

        String dockerImage = "kishwars/pepper_deepvariant:r0.8"
        Int memSizeGB = 128
        Int threadCount = 64
        Int diskSizeGB = 128
    }

    command <<<
        # exit when a command fails, fail with unset variables, print commands before execution
        set -eux -o pipefail
        set -o xtrace

        ID=`basename ~{fastaGZ} | sed 's/.gz$//'`

        gunzip -c ~{fastaGZ} > ${ID}
        samtools faidx ${ID}
    >>>
    output {
        File outFai =  glob("*a")[0]
        File outFasta = glob("*.fai")[0]
    }
    runtime {
        memory: memSizeGB + " GB"
        cpu: threadCount
        disks: "local-disk " + diskSizeGB + " SSD"
        docker: dockerImage
    }
}
