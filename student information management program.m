clear all
clc
table_form = readtable('student database.xlsx');
struct_form = table2struct(table_form);
choice = 0;

%create menu interface
while choice == 0
    disp('This is a student information management program');
    disp('Choose 1 if you want to see student info');
    disp('2 if you want to add new student');
    disp('3 to delete student');
    disp('4 to export the data to the type you want');
    disp('5 to calculate some stats and plot them on subplot');
    disp('6 to escape the program');
    choice = menu('Please choose which options you like',1, 2, 3, 4, 5, 6);
    if choice == 0
        disp('please enter 1, 2, 3, 4, 5 or 6');
    end
end

%Develop branches for menu interface
while choice ~= 6
    switch choice
        case 1
            disp(table_form);
        case 2
            n = numel(struct_form)+1;
            new_student_fullname = input('please enter new student full name: ');
            new_student_year_of_birth = input('please enter new student year of birth: ');
            new_student_place_of_birth = input('please enter new student place of birth: ');
            new_student_gender = menu('please select gender', 'Male', 'Female');
            switch new_student_gender
                case 1
                    new_student_gender = 'Male';
                otherwise
                    new_student_gender = 'Female';
            end
            new_student_class = menu('please choose new student class', 'Honor program', 'Normal program');
            switch new_student_class
                case 1
                    new_student_class = 'Honor program';
                otherwise
                    new_student_class = 'Normal program';
            end
            new_student_status = menu('please choose new student status', 'In progress', 'Quit school');
            switch new_student_status
                case 1
                    new_student_status = 'In progress';
                otherwise
                    new_student_status = 'Quit school';
            end
            struct_form(n).No = n;
            struct_form(n).FullName = new_student_fullname;
            struct_form(n).YearOfBirth = new_student_year_of_birth;
            struct_form(n).PlacesOfBirth = new_student_place_of_birth;
            struct_form(n).Gender = new_student_gender;
            struct_form(n).Class = new_student_class;
            struct_form(n).StudentStatus = new_student_status;
            table_form = struct2table(struct_form);
            writetable(table_form, 'student database.xlsx');
        case 3
            delete_row_options = menu('Please choose number of rows you want to delete', 1, 2, 3);
            switch delete_row_options
                case 1
                    disp(table_form);     %The purpose is to let user decide which row they want to delete
                    r1 = input('please choose row number you want to delete: ');
                    table_form(r, : ) = [];
                    disp(table_form);
                case 2
                    disp(table_form);
                    r1 = input('please enter the first row you want to delete: ');
                    r2 = input('please enter the second row you want to delete: ');
                    table_form([r1 r2], : ) = [];
                    disp(table_form);
                otherwise
                    disp(table_form);
                    r1 = input('please enter the first row you want to delete: ');
                    r2 = input('please enter the second row you want to delete: ');
                    r3 = input('please enter the third row you want to delete: ');
                    table_form([r1 r2 r3], : ) = [];
                    disp(table_form);
            end
        case 4
            data_type = menu('please choose the data type you want', 'excel', 'txt file');
            switch data_type
                case 1
                    writetable(table_form, 'student database final.xlsx', 'Sheet', 1);
                case 2
                    writetable(table_form,'student database final.txt','Delimiter',' ');
            end
        case 5
            %First graph, percent gender
            subplot(2, 2, 1);
            gender_subset = table_form( : , 5);
            array_gender = table2array(gender_subset);
            no_male = nnz(strcmp(array_gender, 'Male'));
            no_female = nnz(strcmp(array_gender, 'Female'));
            pie_chart_data = [no_male no_female];
            graph_pie = pie(pie_chart_data);
            %Second graph, histogram of the distribution of year of birth
            subplot(2, 2, 2);
            x = linspace(0, 10, 100);
            YearOfBirth_subset = table_form( : , 3);
            array_YearOfBirth = table2array(YearOfBirth_subset);
            categorical_form_of_YOB = categorical(array_YearOfBirth);
            histogram_graph = histogram(categorical_form_of_YOB);
            %Third graph, geobubble graph of Places of Birth
            subplot(2, 2, 3);
            POB_subset = table_form( : , 4);
            array_POB = table2array(POB_subset);
            fre_of_POB = tabulate(array_POB);
            fre_of_POB = sortrows(fre_of_POB, 2);
            table_new = cell2table(fre_of_POB);
            lat_subset = table_form( : ,8);
            long_subset = table_form( : ,9);
            array_lat = table2array(lat_subset);
            array_long = table2array(long_subset);
            fre_lat = tabulate(array_lat);
            fre_lat = sortrows(fre_lat, 2);
            fre_long = tabulate(array_long);
            fre_long = sortrows(fre_long, 2);
            lat_value_fre = fre_lat( : ,1);
            long_value_fre = fre_long( : ,1);
            new_table = addvars(table_new, lat_value_fre, long_value_fre);
            new_geo = geobubble(new_table, 'lat_value_fre', 'long_value_fre', 'SizeVariable', 'fre_of_POB2');
            %geo_graph = geobubble(table_form, 'Latitude', 'Longitude');
        otherwise
            break
    end
end