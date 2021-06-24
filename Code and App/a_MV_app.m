classdef a_MV_app < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        SelectImageDropDownLabel       matlab.ui.control.Label
        SelectImageDropDown            matlab.ui.control.DropDown
        BinarizeMethodDropDownLabel    matlab.ui.control.Label
        BinarizeMethodDropDown         matlab.ui.control.DropDown
        LoadImgButton                  matlab.ui.control.Button
        BinarizationButton             matlab.ui.control.Button
        SegmentItButton                matlab.ui.control.Button
        SegmentMethodDropDownLabel     matlab.ui.control.Label
        SegmentMethodDropDown          matlab.ui.control.DropDown
        LocalBinarizeButton            matlab.ui.control.Button
        AppendLabel                    matlab.ui.control.Label
        Rotation90Button               matlab.ui.control.Button
        Rotation35Button               matlab.ui.control.Button
        EdgeDetectionButton            matlab.ui.control.Button
        ThinningButton                 matlab.ui.control.Button
        RearrangementButton            matlab.ui.control.Button
        UIAxes                         matlab.ui.control.UIAxes
        Task1Label                     matlab.ui.control.Label
        Task2Label                     matlab.ui.control.Label
        Task3Label                     matlab.ui.control.Label
        Task4Label                     matlab.ui.control.Label
        Task5Label                     matlab.ui.control.Label
        Task6Label                     matlab.ui.control.Label
        Task7Label                     matlab.ui.control.Label
        Task8Label                     matlab.ui.control.Label
        PleasefollowthetaskorderLabel  matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: SelectImageDropDown
        function SelectImageDropDownValueChanged(app, event)
            value = app.SelectImageDropDown.Value;
                
            
        end

        % Callback function
        function SelectImageDropDownOpening(app, event)
            
        end

        % Button pushed function: LoadImgButton
        function LoadImgButtonPushed(app, event)
           value = app.SelectImageDropDown.Value;
           global img
           if value == 'Image_1'
              close all;
              fileID = fopen('charact1.txt','r');%% open file, permission is 'read'
              formatSpec = '%s';%% define load_format as string
              sizeA = [64,64];
              A1 = fscanf(fileID,formatSpec,sizeA);
              A = A1';
              Mapping = [zeros(1,'0'-1) , 0:9 , zeros(1,'A'-'9'-1) , ('A':'Z')-'A' + 10]; %%Map the ascii code table to numbers
              img = uint8(Mapping(A));%%Use the map to read the picture and standardize its format to uint8
%               figure;
              imshow(img,[0,31],'InitialMagnification','fit','parent',app.UIAxes);
%               %title('original');
           end
           if value == 'Image_2'
              close all;
              img = imread('charact2.jpg');
              img = rgb2gray(img);
              
            %figure;
%             imshow(img,'InitialMagnification','fit','parent',app.UIAxes);
%             %title('original');
            sharp_image=imsharp(img,3);
           
            %figure;
%             imshow(sharp_image,'InitialMagnification','fit','parent',app.UIAxes);
%             %title('sharp');
            smooth_image1 = guassianfilter(sharp_image,3,3);
            img = smooth_image1;
            %figure;
            imshow(img,'InitialMagnification','fit','parent',app.UIAxes);
%             %title('smooth');
           end
           
        end

        % Button pushed function: BinarizationButton
        function BinarizationButtonPushed(app, event)
            method = app.BinarizeMethodDropDown.Value;
            global img
            global img1
                if strcmp(method,'Otus')
                    T = Otsu(img); 
                    img1 = binarize(img,T);
               
                elseif strcmp(method,'Kittler')
                    T = Kittler(img);
                    img1 = binarize(img,T);
                
                elseif strcmp(method,'Iterative')
                    T = Iterative(img);
                    img1 = binarize(img,T);
                
                end
%             figure;
            imshow(img1,'InitialMagnification','fit','parent',app.UIAxes);
%             %title('Binary Image');
            img=img1;
        end

        % Button pushed function: LocalBinarizeButton
        function LocalBinarizeButtonPushed(app, event)

             global img
             fileID = fopen('charact1.txt','r');%% open file, permission is 'read'
             formatSpec = '%s';%% define load_format as string
             size_A = [64,64];
             A1 = fscanf(fileID,formatSpec,size_A);
             A = A1';
             Mapping = [zeros(1,'0'-1) , 0:9 , zeros(1,'A'-'9'-1) , ('A':'Z')-'A' + 10]; %%Map the ascii code table to numbers
             img = uint8(Mapping(A));%%Use the map to read the picture and standardize its format to uint8
%              figure(1);
             imshow(img,'InitialMagnification','fit','parent',app.UIAxes); %imshow�I�[min(I(:)) max(I(:))]�I�������������31�0
%              %title('orginal image','fontsize',8);
            [m,n] = size(img);
            I_gray=double(img);
            T=zeros(m,n);
            M=3;
            N=3; 
            for i=M+1:m-M
                for j=N+1:n-N
                    max=1;min=255;
                    for k=i-M:i+M 
                        for l=j-N:j+N
                            if I_gray(k,l)>max
                                max=I_gray(k,l);
                            end
                            if I_gray(k,l)<min
                                min=I_gray(k,l);
                            end
                        end
                    end
                    %T(i,j)=(max+min)/2;
                     T(i,j)=(max+min)/2;
                end
            end 
              I_bw=zeros(m,n);
              for i=1:m
                  for j=1:n
                     if I_gray(i,j)>T(i,j)
                          I_bw(i,j)=1;
                      else
                          I_bw(i,j)=0;
                     end
                  end
              end 
              Img=logical(I_bw);
%             figure(2)
            imshow(Img,'InitialMagnification','fit','parent',app.UIAxes);
%             %title('Bernsen algorithm');
        end

        % Button pushed function: SegmentItButton
        function SegmentItButtonPushed(app, event)
            method = app.SegmentMethodDropDown.Value;
            global img1
            global img
            global s   
            global kmax
            global sub1
            global sub2
            value = app.SelectImageDropDown.Value;
            if value == 'Image_1'
                kmax = 6;
                sub1 = 2;
                sub2 = 3;
            else
                kmax = 15;
                sub1 = 4;
                sub2 = 4;
            end
           
            if strcmp(method,'Two pass')
                [I,llab,num] = TWO_PASS(img1);
              
                img_rgb = label2rgb(llab,'hsv',[0 0 0],'shuffle');
%                 figure;
%                 imshow(img_rgb,'InitialMagnification','fit','parent',app.UIAxes);
                s = I;
                figure;
                for k=1:kmax
                    subplot(sub1,sub2,k);
                    imshow(s(k).Image,'InitialMagnification','fit');
                end
            elseif strcmp(method,'BFS')
                [I,llab,num] = BFS_connectivity(img1,4);
                
                img_rgb = label2rgb(llab,'hsv',[0 0 0],'shuffle');
%                 figure;
%                 imshow(img_rgb,'InitialMagnification','fit','parent',app.UIAxes);
            end
               
             if strcmp(method,'Quadtree')
                 quadtree(img);
             elseif strcmp(method,'Regional growth')
                 RG(img);
                 
             end
             
           
        end

        % Value changed function: SegmentMethodDropDown
        function SegmentMethodDropDownValueChanged(app, event)
            value = app.SegmentMethodDropDown.Value;
            
        end

        % Callback function
        function SegmentMethodDropDownOpening(app, event)
            
        end

        % Button pushed function: Rotation90Button
        function Rotation90ButtonPushed(app, event)
            global kmax
            global s
            global img1
            global sub1
            global sub2
            global rotate_img
            global centroids
            
            is_full = 1;
            centroids=cat(1,s.Centroid);%get the centroid of the image
            %rotate 90
            figure;
            rotate_img=zeros(size(img1,1));
            for k=1:kmax
                angle=90;
                subplot(sub1,sub2,k);
                rotateimg=img_rotation1(s(k).Image,angle);
                imshow(rotateimg)
                crop_img=TWO_PASS(rotateimg);
                crop_img=TWO_PASS(crop_img.Image);
%                 imshow(crop_img.Image,'InitialMagnification');
                %get the centroid of the rotated image
                for n=-(round(crop_img.Centroid(:,1)-1)):... %Y = round(X),�������
                    size(crop_img.Image,2)-round(crop_img.Centroid(:,1));
                    for m=-(round(crop_img.Centroid(:,2)-1)):...
                            size(crop_img.Image,1)-round(crop_img.Centroid(:,2))
                        if is_full == 1
                            if crop_img.Image(round(crop_img.Centroid(:,2))+m,round(crop_img.Centroid(:,1))+n)==1
                                rotate_img(m+round(centroids(k,2)),n+round(centroids(k,1)))=...
                             crop_img.Image(round(crop_img.Centroid(:,2))+m,round(crop_img.Centroid(:,1))+n);
                            end
                        else
                            rotate_img(m+round(centroids(k,2)),n+round(centroids(k,1)))=...
                             crop_img.Image(round(crop_img.Centroid(:,2))+m,round(crop_img.Centroid(:,1))+n);
                        end
                        %match the centroid of the original image and the rotated image
                    end
                end
            end
            rotate_img=logical(rotate_img);
%             figure;
            imshow(rotate_img,'InitialMagnification','fit','parent',app.UIAxes);%show the image of rotate 90 degree counterclockwise
%             hold on
%             plot(centroids(:,1),centroids(:,2),'R+');
%             hold off
        end

        % Button pushed function: Rotation35Button
        function Rotation35ButtonPushed(app, event)
            global img1 kmax sub1 sub2
            global s centroids
            global rotate_img img
            is_full = 1;
            rotate_img1=zeros(size(rotate_img,1));
            value = app.SelectImageDropDown.Value;
            rotate_img=zeros(size(img1,1));
            for k=1:kmax
                angle=90;
                rotateimg=img_rotation1(s(k).Image,angle);
                %imshow(rotateimage)
                crop_img=TWO_PASS(rotateimg);
                crop_img=TWO_PASS(crop_img.Image);
                s1(k) = crop_img;
            end
            
           if value == 'Image_1'
                t=s1(2).Image;
                s1(2).Image=s1(3).Image;
                s1(3).Image=t;
                t=s1(4).Image;
                s1(4).Image=s1(5).Image;
                s1(5).Image=s1(6).Image;
                s1(6).Image=t;
            end
            
            figure;
            for k=1:kmax
                angle=-35;
                subplot(sub1,sub2,k);
                rotateimg=img_rotation1(s1(k).Image,angle);%rotate the crop image with specific angle.
                crop_img=TWO_PASS(rotateimg);
                crop_img=TWO_PASS(crop_img.Image);
                imshow(crop_img.Image);
                %get the centroid of the rotated image
                rotate_centroids=cat(1,crop_img.Centroid);
                for n=-(round(crop_img.Centroid(:,2)-1)):size(crop_img.Image,1)-round(crop_img.Centroid(:,2))
                    for m=-(round(crop_img.Centroid(:,1)-1)):...
                            size(crop_img.Image,2)-round(crop_img.Centroid(:,1))
                        if is_full == 1
                            if crop_img.Image(round(crop_img.Centroid(:,2))+n,round(crop_img.Centroid(:,1))+m) == 1
                                rotate_img1(n+round(centroids(k,2)),m+round(centroids(k,1)))=...
                                   crop_img.Image(round(crop_img.Centroid(:,2))+n,round(crop_img.Centroid(:,1))+m);
                        %match the centroid of the original image and the rotated image
                            end
                        else
                            rotate_img1(n+round(centroids(k,2)),m+round(centroids(k,1)))=...
                                   crop_img.Image(round(crop_img.Centroid(:,2))+n,round(crop_img.Centroid(:,1))+m);
                        end
                    end
                end
                
            end
            img=logical(rotate_img1);
%             figure;
            imshow(img,'InitialMagnification','fit','parent',app.UIAxes);%show the image of rotate 90 degree counterclockwise
            hold on
            plot(centroids(:,1),centroids(:,2),'R+');
            hold off
        end

        % Button pushed function: EdgeDetectionButton
        function EdgeDetectionButtonPushed(app, event)
            global img1
            Img = classmethod(img1);
%             figure;
            imshow(Img,'InitialMagnification','fit','parent',app.UIAxes);
%             %title('Class Method');

        end

        % Button pushed function: ThinningButton
        function ThinningButtonPushed(app, event)
            global img1
            [imageRow, imageCol] = size(img1);
            midPIC = zeros([imageRow+4, imageCol+4]);
            midPIC(3:end-2, 3:end-2) = img1;
            Img1 = midPIC;
            Img1 = Hild(Img1);
%             figure;
            imshow(Img1,'InitialMagnification','fit','parent',app.UIAxes);
%             %title('Hilditch Algorithm');

        end

        % Button pushed function: RearrangementButton
        function RearrangementButtonPushed(app, event)
            global img1 
            I = TWO_PASS(img1);
            value = app.SelectImageDropDown.Value;
            if value == 'Image_1'
                imethod = 1;
            else 
                imethod = 2;
            end
            out_img = sequence(I,imethod);
%             figure;
            imshow(out_img,'InitialMagnification','fit','parent',app.UIAxes);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create SelectImageDropDownLabel
            app.SelectImageDropDownLabel = uilabel(app.UIFigure);
            app.SelectImageDropDownLabel.HorizontalAlignment = 'right';
            app.SelectImageDropDownLabel.Position = [43 422 76 22];
            app.SelectImageDropDownLabel.Text = 'Select Image';

            % Create SelectImageDropDown
            app.SelectImageDropDown = uidropdown(app.UIFigure);
            app.SelectImageDropDown.Items = {'Image_1', 'Image_2'};
            app.SelectImageDropDown.ValueChangedFcn = createCallbackFcn(app, @SelectImageDropDownValueChanged, true);
            app.SelectImageDropDown.Position = [134 422 100 22];
            app.SelectImageDropDown.Value = 'Image_1';

            % Create BinarizeMethodDropDownLabel
            app.BinarizeMethodDropDownLabel = uilabel(app.UIFigure);
            app.BinarizeMethodDropDownLabel.HorizontalAlignment = 'right';
            app.BinarizeMethodDropDownLabel.Position = [223 339 92 22];
            app.BinarizeMethodDropDownLabel.Text = 'Binarize Method';

            % Create BinarizeMethodDropDown
            app.BinarizeMethodDropDown = uidropdown(app.UIFigure);
            app.BinarizeMethodDropDown.Items = {'Otus', 'Kittler', 'Iterative'};
            app.BinarizeMethodDropDown.Position = [330 339 100 22];
            app.BinarizeMethodDropDown.Value = 'Otus';

            % Create LoadImgButton
            app.LoadImgButton = uibutton(app.UIFigure, 'push');
            app.LoadImgButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImgButtonPushed, true);
            app.LoadImgButton.Position = [109 377 100 22];
            app.LoadImgButton.Text = 'Load Img';

            % Create BinarizationButton
            app.BinarizationButton = uibutton(app.UIFigure, 'push');
            app.BinarizationButton.ButtonPushedFcn = createCallbackFcn(app, @BinarizationButtonPushed, true);
            app.BinarizationButton.Position = [109 339 100 22];
            app.BinarizationButton.Text = 'Binarization';

            % Create SegmentItButton
            app.SegmentItButton = uibutton(app.UIFigure, 'push');
            app.SegmentItButton.ButtonPushedFcn = createCallbackFcn(app, @SegmentItButtonPushed, true);
            app.SegmentItButton.Position = [109 299 100 22];
            app.SegmentItButton.Text = 'Segment It';

            % Create SegmentMethodDropDownLabel
            app.SegmentMethodDropDownLabel = uilabel(app.UIFigure);
            app.SegmentMethodDropDownLabel.HorizontalAlignment = 'right';
            app.SegmentMethodDropDownLabel.Position = [223 299 97 22];
            app.SegmentMethodDropDownLabel.Text = 'Segment Method';

            % Create SegmentMethodDropDown
            app.SegmentMethodDropDown = uidropdown(app.UIFigure);
            app.SegmentMethodDropDown.Items = {'Two pass', 'BFS', 'Quadtree', 'Regional growth'};
            app.SegmentMethodDropDown.ValueChangedFcn = createCallbackFcn(app, @SegmentMethodDropDownValueChanged, true);
            app.SegmentMethodDropDown.Position = [335 299 100 22];
            app.SegmentMethodDropDown.Value = 'Two pass';

            % Create LocalBinarizeButton
            app.LocalBinarizeButton = uibutton(app.UIFigure, 'push');
            app.LocalBinarizeButton.ButtonPushedFcn = createCallbackFcn(app, @LocalBinarizeButtonPushed, true);
            app.LocalBinarizeButton.Position = [279 377 100 22];
            app.LocalBinarizeButton.Text = 'Local Binarize';

            % Create AppendLabel
            app.AppendLabel = uilabel(app.UIFigure);
            app.AppendLabel.Position = [226 377 50 22];
            app.AppendLabel.Text = 'Append:';

            % Create Rotation90Button
            app.Rotation90Button = uibutton(app.UIFigure, 'push');
            app.Rotation90Button.ButtonPushedFcn = createCallbackFcn(app, @Rotation90ButtonPushed, true);
            app.Rotation90Button.Position = [108 262 100 22];
            app.Rotation90Button.Text = 'Rotation 90�';

            % Create Rotation35Button
            app.Rotation35Button = uibutton(app.UIFigure, 'push');
            app.Rotation35Button.ButtonPushedFcn = createCallbackFcn(app, @Rotation35ButtonPushed, true);
            app.Rotation35Button.Position = [109 220 100 22];
            app.Rotation35Button.Text = 'Rotation -35�';

            % Create EdgeDetectionButton
            app.EdgeDetectionButton = uibutton(app.UIFigure, 'push');
            app.EdgeDetectionButton.ButtonPushedFcn = createCallbackFcn(app, @EdgeDetectionButtonPushed, true);
            app.EdgeDetectionButton.Position = [108 179 100 22];
            app.EdgeDetectionButton.Text = 'Edge Detection';

            % Create ThinningButton
            app.ThinningButton = uibutton(app.UIFigure, 'push');
            app.ThinningButton.ButtonPushedFcn = createCallbackFcn(app, @ThinningButtonPushed, true);
            app.ThinningButton.Position = [109 141 100 22];
            app.ThinningButton.Text = 'Thinning';

            % Create RearrangementButton
            app.RearrangementButton = uibutton(app.UIFigure, 'push');
            app.RearrangementButton.ButtonPushedFcn = createCallbackFcn(app, @RearrangementButtonPushed, true);
            app.RearrangementButton.Position = [107 103 103 22];
            app.RearrangementButton.Text = 'Re-arrangement';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, '')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            app.UIAxes.AmbientLightColor = [0.9412 0.9412 0.9412];
            app.UIAxes.PlotBoxAspectRatio = [1.41290322580645 1 1];
            app.UIAxes.Box = 'on';
            app.UIAxes.XColor = [0.9412 0.9412 0.9412];
            app.UIAxes.XTick = [];
            app.UIAxes.YColor = [0.9412 0.9412 0.9412];
            app.UIAxes.YTick = [];
            app.UIAxes.LineWidth = 0.001;
            app.UIAxes.Color = [0.9412 0.9412 0.9412];
            app.UIAxes.TitleFontWeight = 'bold';
            app.UIAxes.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UIAxes.Clipping = 'off';
            app.UIAxes.Position = [240 26 354 258];

            % Create Task1Label
            app.Task1Label = uilabel(app.UIFigure);
            app.Task1Label.Position = [49 377 40 22];
            app.Task1Label.Text = 'Task 1';

            % Create Task2Label
            app.Task2Label = uilabel(app.UIFigure);
            app.Task2Label.Position = [49 339 40 22];
            app.Task2Label.Text = 'Task 2';

            % Create Task3Label
            app.Task3Label = uilabel(app.UIFigure);
            app.Task3Label.Position = [49 299 40 22];
            app.Task3Label.Text = 'Task 3';

            % Create Task4Label
            app.Task4Label = uilabel(app.UIFigure);
            app.Task4Label.Position = [49 262 40 22];
            app.Task4Label.Text = 'Task 4';

            % Create Task5Label
            app.Task5Label = uilabel(app.UIFigure);
            app.Task5Label.Position = [49 220 40 22];
            app.Task5Label.Text = 'Task 5';

            % Create Task6Label
            app.Task6Label = uilabel(app.UIFigure);
            app.Task6Label.Position = [49 179 40 22];
            app.Task6Label.Text = 'Task 6';

            % Create Task7Label
            app.Task7Label = uilabel(app.UIFigure);
            app.Task7Label.Position = [49 141 40 22];
            app.Task7Label.Text = 'Task 7';

            % Create Task8Label
            app.Task8Label = uilabel(app.UIFigure);
            app.Task8Label.Position = [49 103 40 22];
            app.Task8Label.Text = 'Task 8';

            % Create PleasefollowthetaskorderLabel
            app.PleasefollowthetaskorderLabel = uilabel(app.UIFigure);
            app.PleasefollowthetaskorderLabel.FontSize = 16;
            app.PleasefollowthetaskorderLabel.Position = [378 422 204 22];
            app.PleasefollowthetaskorderLabel.Text = 'Please follow the task order';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = a_MV_app

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end