class NewPage::SomePage
  include Lucky::HTMLPage

  ROWS    = 20
  COLUMNS = 10

  def render
    text "this is server-side rendered"
    table class: "striped" do
      tbody do
        (0..ROWS).each do |row|
          tr do
            (1..COLUMNS).each do |cel|
              td "  #{(row * COLUMNS) + cel}"
            end
          end
        end
      end
    end
  end
end
