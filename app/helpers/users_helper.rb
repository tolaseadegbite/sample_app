module UsersHelper

    # Returns gravater for the given user
    def gravatar_for(user, size: 80)
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "https://www.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt: user.name, class: "gravatar")
    end
end
