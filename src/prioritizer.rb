class Prioritizer

  def process_bugs(bugs)
    critical = critical_bugs bugs
    grouped_bugs = split_bugs critical

    grouped_bugs.each do |key, value|
      p '--------------------------------------------------------'
      p "--> List: #{key}"

      value[:bugs].each do |bug|
        p '----------------------------'
        p "Bug title:    #{bug[:title]}"
        p "Bug age:      #{bug[:age]}"
        p "Bug estimate: #{bug[:estimate]}"
        p "Bug priority: #{bug[:priority]}"
      end
    end
  end


  def critical_bugs(bugs)
    bugs.select { |bug| bug[:priority] == 'Crítico' }
  end


  def split_bugs(bugs)
    splitted_bugs = {}

    hours = 0
    index = 0

    until bugs.size == 0 do
      list_name = "list_#{index}".to_sym
      bug = extract_bug bugs, hours

      if bug.nil?
        index += 1
        hours = 0
        next
      end

      estimate_hours = extract_hour bug[:estimate]
      hours += estimate_hours

      splitted_bugs[list_name] = {} if splitted_bugs[list_name].nil?
      splitted_bugs[list_name][:bugs] = [] if splitted_bugs[list_name][:bugs].nil?
      
      splitted_bugs[list_name][:total_hours] = hours
      splitted_bugs[list_name][:bugs] << bug
    end

    splitted_bugs
  end


  def extract_bug(bugs, hours)
    return nil if hours >= 8

    bugs.each_with_index do | bug, index |
      estimate_hours = extract_hour bug[:estimate]
      
      if hours + estimate_hours <= 8
        selected_bug = bug
        bugs.delete_at(index)
        return bug
      end
    end

    nil
  end


  def extract_hour(estimate)
    estimate.split(' ')[0].to_i
  end
end