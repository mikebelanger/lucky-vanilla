class NewPage < BrowserAction
  get "/some_page" do
    html CustomPage::Table
  end
end
