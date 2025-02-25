require "rails_helper"
require "administrate/field/select"

describe "fields/select/_form", type: :view do
  it "displays the field with correct name and selection" do
    customer = build(:customer)
    select = instance_double(
      "Administrate::Field::Select",
      attribute: :email_subscriber,
      data: false,
      selectable_options: [true, false, nil],
      include_blank_option: false
    )

    render(
      partial: "fields/select/form",
      locals: {field: select, f: form_builder(customer)}
    )

    expect(rendered).to have_css(
      %(select[name="customer[email_subscriber]"]
        option[value="false"][selected="selected"])
    )
  end

  it "can include a blank option" do
    customer = build(:customer)
    select = instance_double(
      "Administrate::Field::Select",
      attribute: :email_subscriber,
      data: "Yes",
      selectable_options: ["Yes", "No"],
      include_blank_option: "Unknown"
    )

    render(
      partial: "fields/select/form",
      locals: {field: select, f: form_builder(customer)}
    )

    expect(rendered).to have_css(
      %(select[name="customer[email_subscriber]"] option[value=""]),
      text: "Unknown"
    )
  end

  def form_builder(object)
    ActionView::Helpers::FormBuilder.new(
      object.model_name.singular,
      object,
      build_template,
      {}
    )
  end

  def build_template
    Object.new.tap do |template|
      template.extend ActionView::Helpers::FormHelper
      template.extend ActionView::Helpers::FormOptionsHelper
      template.extend ActionView::Helpers::FormTagHelper
    end
  end
end
