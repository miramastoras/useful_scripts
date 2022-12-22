version 1.0

# index fa file

workflow indexFasta {
    meta {
        author: "Mira Mastoras"
        email: "mmastora@ucsc.edu"
        description: "index fasta file"
    }
    call Index
    output {
        File outFai = Index.outFai
    }

task Separate{
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

        samtools faidx ~{fasta}
    >>>
    output {
        File outFai = "~{fasta}.fai"
    }
    runtime {
        memory: memSizeGB + " GB"
        cpu: threadCount
        disks: "local-disk " + diskSizeGB + " SSD"
        docker: dockerImage
    }
}
