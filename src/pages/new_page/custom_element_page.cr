class NewPage::SomePage < MainLayout
  ROWS = 20
  COLUMNS = 10
  def content
    main class: "some-class" do
      text "this is server-side rendered"
      table do
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
end
