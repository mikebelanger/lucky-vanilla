class Users::IndexPage < MainLayout
  needs user_names : UserQuery

  def content
    ul do
      user_names.each do |user|
        li "#{user.email} : #{user.name}"
      end
    end
  end
end
