class NewPage::SomePage < MainLayout
  def content
    main class: "some-class" do
      text "this is the main page"
    end
  end
end
