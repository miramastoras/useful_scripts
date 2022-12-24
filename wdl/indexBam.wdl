version 1.0

# index bam file

workflow indexFasta {
    meta {
        author: "Mira Mastoras"
        email: "mmastora@ucsc.edu"
        description: "index bam file"
    }
    call Index
    output {
        File outBai = Index.outBai
    }
}

task Index{
    input {
        File inBam

        String dockerImage = "kishwars/pepper_deepvariant:r0.8"
        Int memSizeGB = 128
        Int threadCount = 64
        Int diskSizeGB = 128
    }

    command <<<
        # exit when a command fails, fail with unset variables, print commands before execution
        set -eux -o pipefail
        set -o xtrace

        samtools index ~{inBam}
    >>>
    output {
        File outFai =  glob("*bai")[0]
    }
    runtime {
        memory: memSizeGB + " GB"
        cpu: threadCount
        disks: "local-disk " + diskSizeGB + " SSD"
        docker: dockerImage
    }
}
