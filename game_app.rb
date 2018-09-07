require 'shoes'

Shoes.app(title: "welcome to minigames pack!", width: 400, height: 440) do
  
  # Main layout ___________________________________________________________________________________
  background darkgreen
  # Methods and variables _________________________________________________________________________
  @boxes = {}

  def sizes
    # size of general layout
    @xselfmid = self.width*0.5
    @yselfmid = self.height*0.5

    # variables and coordinates for boxes in playzone
    #borders of playzone
      @xplayleft = @playzone.left
      @yplaytop = @playzone.top
    #box params
      @boxwidth = @playzone.width / 5
      @boxheight = @boxwidth
      @step = 10
    # start position for adding boxes to playzone
      @yplaycenter = @yplaytop + @playzone.height / 2 - @boxwidth / 2
      @xboxleft = @xplayleft + @step*3
    # above param used only for TicTacToe
      @yboxtop = @yplaycenter - @boxheight - @step
  end

  def show_balance
    @balance = 200
    @bal_msg = para "Your balance: ", strong(@balance.to_s), align: 'center', top: 80
  end

  def create_handle
    @rcol = rect(297, 145, self.width*0.02, self.height*0.33, corners=4, fill: orange..red)
    @handle = oval(left: self.width*0.72, top: 140, radius: 15, fill: orangered)
      @handle.click {click_handle}
  end

  def remove_handle
    @handle.remove
    @rcol.remove
  end

  def click_handle
      @anm = animate(30) do |frame|
        @handle.top += 40
          if @handle.top >= 300
            @handle.displace(0, -160)
            @anm.stop
            #delete handle & create new one to restart animation
              remove_handle
              create_handle
          end
      end
  end

  def g1start_alert
    timer 1 do
      stack margin_left: 2, align:'left' do
        alert(
        "       Three equal numbers gives you +10$
        Magic combi (777, 333, 555) gives you +100$
        Different numbers takes -5$
        Three zeroes - you`re bancrupt\n
        Push the handle, and good luck!")
      end
    end
  end

  def create_boxes
    sizes
       # first, is to check wich game has started and so decide about 1st box position
       # @balance variable assigned only in Slot machine
      @yplaycenter = @yboxtop if !@balance
        1.upto 9 do |z|
          box = rect(@xboxleft, @yplaycenter, @boxwidth, @boxheight, corners=4, fill: white)
           # here is creating array with boxes names & coordinates
          @boxes["box"<<z.to_s] = "#{box.left}, #{box.top}"
           # moving boxes over the playzone
          @xboxleft = ("#{box.left}".to_i + @boxwidth + @step)
            # change x,y when row is ended
            @xboxleft = (@xplayleft + @step*3) if (z == 3 || z == 6)
            @yplaycenter += (@boxwidth + @step) if (z == 3 || z == 6)
           # end loop after 3rd box created (rule for Slot machine)
          break if @balance && z == 3
        end
  end
 
    stack(margin: 10) do
      flow(margin: 2) do
        btn_slotmachine = button "Slot machine", width: 90, heigth: 35, margin_right: 4 do
          show_balance
          create_handle
          create_boxes
          g1start_alert
        

        end
        para strong "Play this classic casino game!", stroke: white
      end

      flow(margin: 2) do
        btn_tictac = button "Tic-Tac-Toe", width: 90, heigth: 35, margin_right: 4 do
          create_boxes
        end
        para strong "Miss about school years? Try it!", stroke: white
      end
    end

    # widht & height values used in % of window_App size
    @playzone = rect(70, 110, self.width*0.65, self.height*0.55, corners=4, fill: darkgoldenrod)

    #control buttons
    flow(left: self.width*0.27, top: self.height-80)  do
      button "Restart", width: 60, margin: 2
      button "End", width: 60, margin: 2
      button "Exit App", width: 60, margin: 2
    end

end