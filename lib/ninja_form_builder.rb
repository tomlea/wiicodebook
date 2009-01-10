class NinjaFormBuilder < ActionView::Helpers::FormBuilder
    (field_helpers - ["hidden_field", "select"]).each do |method_name|
      src = 'def %s(label, options = {});  simple_field(options.delete(:label){label.to_s.humanize}, super(label, options), "\#{@object_name}_\#{label}"); end'
      src = src % method_name.to_s
      class_eval src, __FILE__, __LINE__
    end

    def select(name, values, options = {})
      simple_field(options.delete(:label){label.to_s.humanize}, super(name, values, options), "\#{@object_name}_\#{label}")
    end

    def simple_field(label, field, id)
      '<p><label for="%s">%s</label><br/>%s</p>' % [id, label, field]
    end
end

