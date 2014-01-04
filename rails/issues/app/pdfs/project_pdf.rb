class ProjectPdf < Prawn::Document
  def initialize(project, view)
    super(top_margin: 70)
    @project = project
    @view = view
    project_name
    line_item
    total_number
  end
  def project_name
    text "#{@project.name} goes here", size: 30, style: :bold
  end
  def line_item
    move_down 20
    # table [[1,2], [3,4]]
    table line_item_rows do #|table|
      row(0).font_style = :bold
      columns(0..4).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end
  def line_item_rows
    [["Issue Id", "Name", "Description", "Created_at", "Updated_at"]] + 
    @project.issues.map do |issue|
      [price(issue.id), issue.name, issue.description, issue.created_at.to_s, issue.updated_at.to_s]
    end
  end

  def price(num)
    @view.number_to_currency(num)
  end

  def total_number
    move_down 15
    text "Total number of issues: #{price(@project.issues.count)}", size: 16, style: bold
  end
end