function Mplot(Element, Force)
force_num = max(size(Force));
element_num = max(size(Element));
flag = [];
Forceindex = [];
for i = 1: force_num
    if Force(i).kind == 2
        flag = [flag, Force(i).exert_index];
        Forceindex = [Forceindex, i];
    end
end


for i = 1: element_num
    plotforce(1) = -Element(i).force(1);
    plotforce(2) = -Element(i).force(2);
    plotforce(3) = -Element(i).force(3);
    plotforce(4) = Element(i).force(4);
    plotforce(5) = Element(i).force(5);
    plotforce(6) = Element(i).force(6);

    % if there is an external force
    %   if it is a force
    %       x,y 3 point
    %   if it is a distribute force
    %       x,y interpolate to a parabolic
    %else there is not any external force
    %   link both ends directly

    with_external_force = find(flag == i);
    if with_external_force > 0
        force_num = Forceindex(with_external_force);
        if Force(force_num).category == 2
            if sin(Element(i).alpha) ~= 0 % for verticle condition
                x = [Element(i).joint1.x, Element(i).joint1.x, Element(i).joint2.x];
                y = [Element(i).joint1.y, Element(i).joint1.y + Force(force_num).distance, Element(i).joint2.y];
                middle = (-Force(force_num).value*Element(i).l)/4 + (plotforce(3)+plotforce(6))/2;
                Mz_x = x + [plotforce(3),  middle, plotforce(6)]/abs(Element(1).force(3));
                Mz_y = y;
            else
                x = [Element(i).joint1.x, Element(i).joint1.x + Force(force_num).distance,  Element(i).joint2.x];
                y = [Element(i).joint1.y, Element(i).joint1.y, Element(i).joint2.y];
                Mz_x = x;
                middle = (-Force(force_num).value*Element(i).l)/4 + (plotforce(3)+plotforce(6))/2;
                Mz_y = y + [plotforce(3),  middle, plotforce(6)]/abs(Element(1).force(3));
            end
            plot(x,y,'lineWidth',2, 'Color', 'black')
            hold on;
            text(Mz_x(1), Mz_y(1),num2str(plotforce(3),'%.3f'),'FontSize',14)
            text(Mz_x(end), Mz_y(end),num2str(plotforce(6),'%.3f'),'FontSize',14)
            text(Mz_x(2), Mz_y(2),num2str(-Force(force_num).value * Element(i).l /4 +(plotforce(3)+plotforce(6))/2,'%.3f'),'FontSize',14)
            plot(Mz_x,Mz_y,'lineWidth',2, 'Color', 'blue')
            plot([x(1), Mz_x(1)],[y(1),Mz_y(1)],'lineWidth',2, 'Color', 'blue')
            plot([x(end), Mz_x(end)],[y(end),Mz_y(end)],'lineWidth',2, 'Color', 'blue')
        elseif Force(force_num).category == 3
            if sin(Element(i).alpha) ~= 0 % for verticle condition
                x = [Element(i).joint1.x, Element(i).joint1.x, Element(i).joint2.x];
                y = [Element(i).joint1.y, Element(i).joint1.y + Element(i).l/2, Element(i).joint2.y];
                middle = (-Force(force_num).value*Element(i).l^2)/8 + (plotforce(3)+plotforce(6))/2;
                Mz_x = x + [plotforce(3), middle, plotforce(6)]/abs(Element(1).force(3));
                Mz_y = y;
                p = polyfit(Mz_y, Mz_x, 2);
                Mz_yy = linspace(Mz_y(1),Mz_y(end),100);
                Mz_xx = polyval(p,Mz_yy);
            else
                x = [Element(i).joint1.x, Element(i).joint1.x + Element(i).l/2, Element(i).joint2.x];
                y = [Element(i).joint1.y, Element(i).joint1.y, Element(i).joint2.y];
                Mz_x = x;
                middle = (-Force(force_num).value*Element(i).l^2)/8 + (plotforce(3)+plotforce(6))/2;
                Mz_y = y + [plotforce(3), middle, plotforce(6)]/abs(Element(1).force(3));
                p = polyfit(Mz_x, Mz_y, 2);
                Mz_xx = linspace(Mz_x(1),Mz_x(end),100);
                Mz_yy = polyval(p,Mz_xx);
            end
            plot(x,y,'lineWidth',2, 'Color', 'black')
            hold on;
            text(Mz_x(1), Mz_y(1),num2str(plotforce(3),'%.3f'),'FontSize',14)
            text(Mz_x(end), Mz_y(end),num2str(plotforce(6),'%.3f'),'FontSize',14)
            text(Mz_x(2), Mz_y(2),num2str(-Force(force_num).value * Element(i).l^2/8 +(plotforce(3)+plotforce(6))/2,'%.3f'),'FontSize',14)
            plot(Mz_xx,Mz_yy,'lineWidth',2, 'Color', 'blue')
        end
    else
        x = [Element(i).joint1.x, Element(i).joint2.x];
        y = [Element(i).joint1.y, Element(i).joint2.y];
        if sin(Element(i).alpha) ~= 0 % for verticle condition
            Mz_x = [x(1) + plotforce(3)/abs(Element(1).force(3)), x(2) + plotforce(6)/abs(Element(1).force(3))];
            Mz_y = y;
        else
            Mz_x = x;
            Mz_y = [y(1) + plotforce(3)/abs(Element(1).force(3)), y(2) + plotforce(6)/abs(Element(1).force(3))];
        end
        plot(x,y,'lineWidth',2, 'Color', 'black')
        hold on;
        text(Mz_x(1), Mz_y(1),num2str(plotforce(3),'%.3f'),'FontSize',14)
        text(Mz_x(end), Mz_y(end),num2str(plotforce(6),'%.3f'),'FontSize',14)
        plot(Mz_x,Mz_y,'lineWidth',2, 'Color', 'blue')
        plot([x(1), Mz_x(1)],[y(1),Mz_y(1)],'lineWidth',2, 'Color', 'blue')
        plot([x(2), Mz_x(2)],[y(2),Mz_y(2)],'lineWidth',2, 'Color', 'blue')
    end
end

title("弯矩图","FontSize",14)
xlabel("x/m","FontSize",14)
ylabel("y/m","FontSize",14)
end