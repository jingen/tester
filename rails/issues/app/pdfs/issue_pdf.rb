class IssuePdf < Prawn::Document
  def initialize(issue)
    super(top_margin: 70)
    @issue = issue
    issue_name
    line_item
  end
  def issue_name
    text "#{@issue.name} goes here", size: 30, style: :bold
  end
  def line_item
    move_down 20
    table [[1,2], [3,4]]
  end
  # def line_item_rows
  #   [["Product", "Qty", "Unit Price", "Full Price"]] + 
  #   @issue.line_item.map do |item|
  #     [item.name, item.quantity, item.unit_price, item.full_price]
  #   end
  # end
end