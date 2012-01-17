class ferm::rsync {
    @ferm::rule { "dsa-rsync":
        domain          => "(ip ip6)",
        description     => "Allow rsync access",
        rule            => "&SERVICE(tcp, 873)"
    }
}

