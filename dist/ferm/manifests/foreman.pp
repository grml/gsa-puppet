class ferm::foreman {
    @ferm::rule { "foreman":
        description     => "Allow foreman access",
        rule            => "&SERVICE( tcp, 3000 )"
    }
}

