require 'Date'

class Travel_plan
  attr_reader :name, :price, :id

  @@count = 0
  def initialize(**travel_plan_params)
    @name = travel_plan_params[:name]
    @price = travel_plan_params[:price]
    @id = @@count += 1
  end

end

class Travel_agency
  attr_reader :travel_plans

  DATE_CHECK_NUM = 3

  def initialize(travel_plan_params)
    @travel_plans = travel_plan_params.map {|param| Travel_plan.new(param)}
  end

  def disp_plan
    puts "旅行プランを選択してください"

    @travel_plans.each do |param|
      puts "#{param.id}.#{param.name}(¥#{param.price.number_with_separator}円)"
    end
  end
  
  def calculate_charges(user)
    @total_price = user.chosen_plan.price * user.num_of_people

     date_check(user.today)
     num_of_people_check(user.num_of_people)
     departure_day_check(user.departure_day, user.today)
    
    puts "合計金額: ¥#{@total_price.floor.number_with_separator}円"

  end

  def date_check(today)
    
    # 今日の日付が5のつく日か調べる
    if date_check = today.day.digits[0].to_s.include?(DATE_CHECK_NUM.to_s)
    
      puts "今日は#{today.strftime("%Y年%m月%d日")}です。#{DATE_CHECK_NUM}がつく日は10%割引となります。"
      @total_price *= 0.9
    end
  
  end

  def departure_day_check(departure_day, today)
    puts "出発日は#{departure_day.strftime("%Y年%m月%d日")}ですね"

    after_day = today.next_day(14)

    # 出発日が今日から14日後かどうかの処理
    if departure_day >= after_day
      @total_price *= 0.9
      puts "14日前までの予約は10%割引となります。"
    end
    
  end

  def num_of_people_check(num_of_people)
    if num_of_people >= 5
      puts "5人以上なので10%割引となります"
      @total_price *= 0.9
    end
  end

end

class User
  attr_reader :chosen_plan, :num_of_people, :departure_day, :today

  def select_plan(travel_plans)
    while true do
      print "プランを選択 > "
      select_plan = gets.to_i
      @chosen_plan = travel_plans.find { |plan| plan.id == select_plan}
      
      break if (travel_plans.first.id..travel_plans.last.id) === select_plan
      puts "#{travel_plans.first.id}から#{travel_plans.last.id}の中から選んでください。"
    end
  end

  def num_of_people_input
    puts "#{@chosen_plan.name}ですね、何人で行きますか?"

    while true do
      print "人数を入力 > "
      @num_of_people = gets.to_i
      break if @num_of_people >= 1
      puts "１人以上を入力してください"
    end
  end

  def departure_day_input
    puts "出発日を入力して下さい"

    while true do
      print "年 > "
      date_y = gets.to_i
      print "月 > "
      date_m = gets.to_i
      print "日 > "
      date_d = gets.to_i

      begin
        # 入力された出発日が有効か調べる
        @departure_day = Date.parse("#{date_y}/#{date_m}/#{date_d}")
        @today = Date.today
        break if @departure_day > today
        puts "明日以降の日付を入力してください"
      rescue
        puts "無効な日付です"
      end
    end
  end

end

class Integer
  # 数字に3桁区切りのカンマを入れる
  def number_with_separator
    return self.to_s.gsub(/(\d)(?=\d{3}+$)/, '\\1,')
  end
end

travel_plan_params = [
  { name: "沖縄旅行", price: 10000 },
  { name: "北海道旅行", price: 20000 },
  { name: "九州旅行", price: 15000 }
]

travel_agency = Travel_agency.new(travel_plan_params)
travel_agency.disp_plan

user = User.new
user.select_plan(travel_agency.travel_plans)
user.num_of_people_input
user.departure_day_input

travel_agency.calculate_charges(user)
