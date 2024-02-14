function [plot_res,num_res] = ZSLAB_nodal_2D(RESULTS,OPTIONS,TEMPLATE_FIGURE)
%-------------------------------------------------------------------------------
% Name:           ZSLAB_nodal_2D
% Purpose:        This function displays the nodal results taken from the RES
%                 struct
%
% Author:         Minini Jocelyn
%
% Last Update:    17.08.2023
% Version:        2023.01
% Licence:        free
%-------------------------------------------------------------------------------

%% Check input arguments
% Suppress warnings 
warning('off','MATLAB:MKDIR:DirectoryExists')
warning('off','MATLAB:print:ContentTypeImageSuggested')

% Check first arg
if ~isstruct(RESULTS)
    error('First argument must be a data struct.')
end

mandatory_fields = ["HISTORY_his";"MESH_dat";"NODAL_s00"];

for i = 1:length(mandatory_fields)
    if ~isfield(RESULTS,mandatory_fields(i,:))
        error(strcat('The RESULTS struct must contain "',mandatory_fields(i,:),'.'))
    end
end

% Check second arg
if ~isstruct(OPTIONS)
    error('Second argument must be a data struct.')
end

mandatory_fields = ["QoI";"TimeStep";"Driver"];

for i = 1:length(mandatory_fields)
    if ~isfield(OPTIONS.Results,mandatory_fields(i,:))
        error(strcat('The OPTIONS struct must contain "',mandatory_fields(i,:),'.'))
    end
end

dat = RESULTS.MESH_dat;
s00 = RESULTS.NODAL_s00;
his = RESULTS.HISTORY_his;


%% Configure the selection
% Step selection
selection_index = ZSLAB_select_time_step(his,OPTIONS);
n_selection = sum(selection_index);

% Element selection
continuum_2d_el = ["Q4";"T3";"Q8";"Q9";"T6";"T15";"Q4ES";"SPL2";"SPL3"];

el_index = boolean(zeros(dat.ELEMENTS.N,1));

for i = 1:length(continuum_2d_el)
    el_index = el_index + strcmp(dat.ELEMENTS.TYPE,continuum_2d_el(i,:));
end

el_index = boolean(el_index);


%% Numerical results
% Nodal result folder
path = ZSLAB_results_folder(OPTIONS);
res_path = [path,'\NODAL'];
mkdir(res_path)

% File name for numerical results
if ~isfield(OPTIONS.File,"Name")
    file_name = 'ZS_Results_NODAL';
else
    file_name = OPTIONS.File.Name;
end

% Numerical results
time_steps = RESULTS.HISTORY_his.TIME(selection_index);
n_QoI = length(OPTIONS.Results.QoI);
for i = 1:n_QoI
    num_res.(OPTIONS.Results.QoI(i)) = s00.(sprintf(upper(OPTIONS.Results.QoI(i))))(:,selection_index);
end
save(fullfile(res_path,file_name),"num_res")


%% Graphical results configuration 
F = dat.ELEMENTS.NODES_INDEX;
F = F(el_index,:);
F = cell2mat(F);
V = dat.NODES.XYZ;

% Extension
if ~isfield(OPTIONS.File,"Extension")
    file_extension = ".pdf"; % Default value
else
    if ~isstring(OPTIONS.File.Extension)
        error("'Extension' parameter must be a string")
    else
        file_extension = OPTIONS.File.Extension;
    end
end

% Image resolution
if ~isfield(OPTIONS.File,"Resolution")
    file_resolution = 300; % Default value
else
    if ~isnumeric(OPTIONS.File.Resolution)
        error("'Resolution' parameter must be an integer value")
    else
        file_resolution = OPTIONS.File.Resolution;
    end
end

% Parallel execution
if ~isfield(OPTIONS.File,"ParallelExe")
    par_exe = false; % Default value
else
    if ~islogical(OPTIONS.File.ParallelExe)
        error("'ParallelExe' parameter must be a logical value (true/false)")
    else
        par_exe = OPTIONS.File.ParallelExe;
    end
end

% Make video
if ~isfield(OPTIONS.File,"Movie")
    make_movie = false; % Default value
else
    if ~islogical(OPTIONS.File.Movie)
        error("'Movie' parameter must be a logical value (true/false)")
    else
        make_movie = OPTIONS.File.Movie;
    end
end

% Vector field
if ~isfield(OPTIONS.File,"VectorField")
    vector_field_make = false; % Default value
else
    if ~isfield(OPTIONS.File.VectorField,"Generation")
        error("At least 'VectorField.Generation' should be given")
    else
        if ~islogical(OPTIONS.File.VectorField.Generation)
            error("'VectorField.Generation' parameter must be a logical value (true/false)")
        else
            vector_field_make = OPTIONS.File.VectorField.Generation;
        end
    end

    if ~isfield(OPTIONS.File.VectorField,"ScaleFactor")
        vector_field_scale_factor = 1;
    else
        if ~isnumeric(OPTIONS.File.VectorField.ScaleFactor)
            error("'VectorField.ScaleFactor' parameter must be a numercial value")
        else
            vector_field_scale_factor = OPTIONS.File.VectorField.ScaleFactor;
        end
    end

    if ~isfield(OPTIONS.File.VectorField,"Color")
        vector_field_color = [0.15,0.15,0.15];
    else
        if ~isvector(OPTIONS.File.VectorField.Color)
            error("'VectorField.Color' parameter must be a numerical array")
        else
            vector_field_color = OPTIONS.File.VectorField.Color;
        end
    end
end

%% Images generation
file_name_with_path = ZSLAB_results_file_name(selection_index,res_path,his,OPTIONS);


for j = 1:n_QoI
    temp_path = strcat(res_path,'\',OPTIONS.Results.QoI(j));
    mkdir(temp_path)
    if ~par_exe
        for i = 1:n_selection

            figure(i) = TEMPLATE_FIGURE;
            
            graph = patch('Faces',F,'Vertices',V,'FaceVertexCData',OPTIONS.Results.ScaleFactor(j)*num_res.(OPTIONS.Results.QoI(j))(:,i),'FaceColor','interp','LineWidth',0.01,'EdgeColor',[0.1,0.1,0.1]);
            
            hold on
            
            % Vector field
            if vector_field_make
                X = RESULTS.MESH_dat.NODES.XYZ(:,1);
                Y = RESULTS.MESH_dat.NODES.XYZ(:,2);
                U1 = s00.UX(:,selection_index);
                U1 = U1(:,i);
                U2 = s00.UY(:,selection_index);
                U2 = U2(:,i);
                vf_graph = quiver(X,Y,U1,U2,vector_field_scale_factor);
            end
            set(vf_graph,'Color',vector_field_color)
            set(vf_graph,'LineWidth',0.1)
            
            
            
            nodes_bounds = minmax(RESULTS.MESH_dat.NODES.XYZ');
            daspect([1 1 1]);
            ax = gca;
            
            if strcmp(ax.XLimMode,'auto') & strcmp(ax.YLimMode,'auto')
                xlim([nodes_bounds(1,1)-2,nodes_bounds(1,2)+2])
                ylim([nodes_bounds(2,1)-2,nodes_bounds(2,2)+2])
            end
            
            % Export format
            temp = file_name_with_path.(OPTIONS.Results.QoI(j));
            temp = temp(i);
            
            if strcmp(file_extension,".pdf")
                exportgraphics(gca,temp,'ContentType','vector');
            else
                exportgraphics(gca,temp,'Resolution',file_resolution);
            end
            
            plot_res(i) = figure(i);
            disp(strcat("Nodal result '",OPTIONS.Results.QoI(j),"' at Time = ",num2str(time_steps(i)),"... Saved"))
            cla
    
        end
    else
        parfor i = 1:n_selection

            figure(i) = TEMPLATE_FIGURE;

            graph = patch('Faces',F,'Vertices',V,'FaceVertexCData',OPTIONS.Results.ScaleFactor(j)*num_res.(OPTIONS.Results.QoI(j))(:,i),'FaceColor','interp');
            set(graph,'LineWidth',0.01)
            set(graph,'EdgeColor',[0.1,0.1,0.1])
            
            hold on
            
            % Vector field
            if vector_field_make
                X = RESULTS.MESH_dat.NODES.XYZ(:,1);
                Y = RESULTS.MESH_dat.NODES.XYZ(:,2);
                U1 = s00.UX(:,selection_index);
                U1 = U1(:,i);
                U2 = s00.UY(:,selection_index);
                U2 = U2(:,i);
                quiver(X,Y,U1,U2,vector_field_scale_factor,'Color',vector_field_color,'LineWidth',0.1);
            end
                        
            nodes_bounds = minmax(RESULTS.MESH_dat.NODES.XYZ');
            daspect([1 1 1]);
            ax = gca;
            
            if strcmp(ax.XLimMode,'auto') & strcmp(ax.YLimMode,'auto')
                xlim([nodes_bounds(1,1)-2,nodes_bounds(1,2)+2])
                ylim([nodes_bounds(2,1)-2,nodes_bounds(2,2)+2])
            end
            
            % Export format
            temp = file_name_with_path.(OPTIONS.Results.QoI(j));
            temp = temp(i);
            
            if strcmp(file_extension,".pdf")
                exportgraphics(gca,temp,'ContentType','vector');
            else
                exportgraphics(gca,temp,'Resolution',file_resolution);
            end
        
            disp(strcat("Nodal result '",OPTIONS.Results.QoI(j),"' at Time = ",num2str(time_steps(i)),"... Saved"))
            cla

        end          
    end
end

close all
disp(strcat("'Nodal results' : All files were successfully generated !"))

%% Movie generation


end