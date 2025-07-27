class NewPage < BrowserAction
  get "/some_page" do
    html NewPage::SomePage
  end
end
