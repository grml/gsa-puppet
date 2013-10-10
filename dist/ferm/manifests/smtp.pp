class ferm::smtp {
    @ferm::rule { "smtp":
        description     => "Allow smtp access",
        rule            => "&SERVICE(tcp, smtp)"
    }
    @ferm::rule { "submission":
        description     => "Allow submission access",
        rule            => "&SERVICE(tcp, submission)"
    }
    @ferm::rule { "smtps":
        description     => "Allow smtps access",
        rule            => "&SERVICE(tcp, smtps)"
    }
}

