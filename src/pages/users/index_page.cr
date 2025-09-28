class Users::IndexPage < MainLayout
  needs user_names : Array(String)

  def content
    ul do
      user_names.each do |user|
        li user
      end
    end
  end
end
