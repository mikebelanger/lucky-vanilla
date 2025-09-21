class CardContainer < BaseComponent
  def render
    section class: "card" do
      div do
        yield
      end
    end
  end
end
