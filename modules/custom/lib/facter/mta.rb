Facter.add("mta") do
	setcode do
		mta = "exim4"
		if FileTest.exist?("/usr/sbin/postfix")
			mta = "postfix"
		end
		mta
	end
end

