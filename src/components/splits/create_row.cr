class Splits::CreateRow
  include Lucky::HTMLPage

  def render
    now = Time.utc
    new_split_id = "new-split-id"

    form(id: new_split_id, action: "/splits/create", is: "split-row-form", method: "post", replace_id: "replace-me")
    tr do
      td do
        para "For which month? "
      end
      td colspan: 2 do
        tag("select") do
          Month.values.each do |month|
            option do
              text month.to_s
            end
          end
        end
      end
    end
    tr do
      td do
        para "For which year? "
      end
      td colspan: 2 do
        tag("select") do
          (2020..now.year).reverse_each do |year|
            option do
              text year.to_s
            end
          end
        end
      end
      td do
      end
      td colspan: 2 do
        button form: new_split_id, type: "submit", method: "POST" do
          text "Create new split"
        end
      end
    end
  end
end
