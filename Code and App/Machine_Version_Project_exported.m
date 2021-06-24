classdef Machine_Version_Project_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        SelectImageDropDownLabel     matlab.ui.control.Label
        SelectImageDropDown          matlab.ui.control.DropDown
        BinarizeMethodDropDownLabel  matlab.ui.control.Label
        BinarizeMethodDropDown       matlab.ui.control.DropDown
        Load_ImgButton               matlab.ui.control.Button
        BinarizeButton               matlab.ui.control.Button
        SegmentButton                matlab.ui.control.Button
        SegmentMethodDropDownLabel   matlab.ui.control.Label
        SegmentMethodDropDown        matlab.ui.control.DropDown
        LocalBinarizeButton          matlab.ui.control.Button
        AppendLabel                  matlab.ui.control.Label
        Rotation90Button             matlab.ui.control.Button
        Rotation35Button             matlab.ui.control.Button
        EdgedetectionButton          matlab.ui.control.Button
        ThinButton                   matlab.ui.control.Button
        arrangementButton            matlab.ui.control.Button
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: SelectImageDropDown
        function SelectImageDropDownValueChanged(app, event)
            value = app.SelectImageDropDown.Value;
       
                
            
        end

        % Drop down opening function: SelectImageDropDown
        function SelectImageDropDownOpening(app, event)
            
        end

        % Button pushed function: Load_ImgButton
        function Load_ImgButtonPushed(app, event)
           value = app.SelectImageDropDown.Value;
           global img
           if value == 'Image_1'
              
              fileID = fopen('charact1.txt','r');%% open file, permission is 'read'
              formatSpec = '%s';%% define load_format as string
              sizeA = [64,64];
              A1 = fscanf(fileID,formatSpec,sizeA);
              A = A1';
              Mapping = [zeros(1,'0'-1) , 0:9 , zeros(1,'A'-'9'-1) , ('A':'Z')-'A' + 10]; %%Map the ascii code table to numbers
              img = uint8(Mapping(A));%%Use the map to read the picture and standardize its format to uint8
              figure;
              imshow(img,[0,31],'InitialMagnification','fit');
              title('original');
           end
           if value == 'Image_2'
              
              img = imread('charact2.jpg');
              img = rgb2gray(img);
              
            figure;
            imshow(img,'InitialMagnification','fit');
            title('original');
            sharp_image=imsharp(img,3);
           
            figure;
            imshow(sharp_image,'InitialMagnification','fit');
            title('sharp');
            smooth_image1 = guassianfilter(sharp_image,3,3);
            img = smooth_image1;
            figure;
            imshow(img,'InitialMagnification','fit');
            title('smooth');
           end
           
        end

        % Button pushed function: BinarizeButton
        function BinarizeButtonPushed(app, event)
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
            figure;
            imshow(img1,'InitialMagnification','fit');
            title('Binary Image');
        end

        % Button pushed function: LocalBinarizeButton
        function LocalBinarizeButtonPushed(app, event)
             clc; 
             clear all;
             close all;
             fileID = fopen('charact1.txt','r');%% open file, permission is 'read'
             formatSpec = '%s';%% define load_format as string
             size_A = [64,64];
             A1 = fscanf(fileID,formatSpec,size_A);
             A = A1';
             Mapping = [zeros(1,'0'-1) , 0:9 , zeros(1,'A'-'9'-1) , ('A':'Z')-'A' + 10]; %%Map the ascii code table to numbers
             img = uint8(Mapping(A));%%Use the map to read the picture and standardize its format to uint8
             figure(1);
             imshow(img,[0,31]); %imshow（I，[min(I(:)) max(I(:))]）I中数值最大值与最小值分别为31和0
             title('orginal image','fontsize',8);
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
            figure(2)
            imshow(Img);
            title('Bernsen algorithm');
        end

        % Button pushed function: SegmentButton
        function SegmentButtonPushed(app, event)
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
                figure;imshow(img_rgb,'InitialMagnification','fit');
                s = I;
                figure;
                for k=1:kmax
                    subplot(sub1,sub2,k);
                    imshow(s(k).Image,'InitialMagnification','fit');
                end
            elseif strcmp(method,'BFS')
                [I,llab,num] = BFS_connectivity(img1,4);
                
                img_rgb = label2rgb(llab,'hsv',[0 0 0],'shuffle');
                figure;imshow(img_rgb,'InitialMagnification','fit');
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

        % Drop down opening function: SegmentMethodDropDown
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
                %imshow(rotateimage)
                crop_img=TWO_PASS(rotateimg);
                crop_img=TWO_PASS(crop_img.Image);
                imshow(crop_img.Image,'InitialMagnification','fit');
                %get the centroid of the rotated image
                for n=-(round(crop_img.Centroid(:,1)-1)):... %Y = round(X),对元素四舍五入
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
            figure;
            imshow(rotate_img,'InitialMagnification','fit');%show the image of rotate 90 degree counterclockwise
            hold on
            plot(centroids(:,1),centroids(:,2),'R+');
            hold off
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
            figure;
            imshow(img,'InitialMagnification','fit');%show the image of rotate 90 degree counterclockwise
            hold on
            plot(centroids(:,1),centroids(:,2),'R+');
            hold off
        end

        % Button pushed function: EdgedetectionButton
        function EdgedetectionButtonPushed(app, event)
            global img
            IMG = classmethod(img);
            figure;
            imshow(IMG,[0,1],'InitialMagnification','fit');title('Class Method');

        end

        % Button pushed function: ThinButton
        function ThinButtonPushed(app, event)
            global img
            [imageRow, imageCol] = size(img);
            midPIC = zeros([imageRow+4, imageCol+4]);
            midPIC(3:end-2, 3:end-2) = img;
            img = midPIC;
            img = Hild(img);
            figure;
            imshow(img,'InitialMagnification','fit'); title('Hilditch Algorithm');

        end

        % Button pushed function: arrangementButton
        function arrangementButtonPushed(app, event)
            global img1 
            I = TWO_PASS(img1);
            value = app.SelectImageDropDown.Value;
            if value == 'Image_1'
                imethod = 1;
            else 
                imethod = 2;
            end
            out_img = sequence(I,imethod);
            figure;
            imshow(out_img,'InitialMagnification','fit');
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
            app.SelectImageDropDownLabel.Position = [26 403 76 22];
            app.SelectImageDropDownLabel.Text = 'Select Image';

            % Create SelectImageDropDown
            app.SelectImageDropDown = uidropdown(app.UIFigure);
            app.SelectImageDropDown.Items = {'Image_1', 'Image_2'};
            app.SelectImageDropDown.DropDownOpeningFcn = createCallbackFcn(app, @SelectImageDropDownOpening, true);
            app.SelectImageDropDown.ValueChangedFcn = createCallbackFcn(app, @SelectImageDropDownValueChanged, true);
            app.SelectImageDropDown.Position = [117 403 100 22];
            app.SelectImageDropDown.Value = 'Image_1';

            % Create BinarizeMethodDropDownLabel
            app.BinarizeMethodDropDownLabel = uilabel(app.UIFigure);
            app.BinarizeMethodDropDownLabel.HorizontalAlignment = 'right';
            app.BinarizeMethodDropDownLabel.Position = [145 334 92 22];
            app.BinarizeMethodDropDownLabel.Text = 'Binarize Method';

            % Create BinarizeMethodDropDown
            app.BinarizeMethodDropDown = uidropdown(app.UIFigure);
            app.BinarizeMethodDropDown.Items = {'Otus', 'Kittler', 'Iterative'};
            app.BinarizeMethodDropDown.Position = [252 334 100 22];
            app.BinarizeMethodDropDown.Value = 'Otus';

            % Create Load_ImgButton
            app.Load_ImgButton = uibutton(app.UIFigure, 'push');
            app.Load_ImgButton.ButtonPushedFcn = createCallbackFcn(app, @Load_ImgButtonPushed, true);
            app.Load_ImgButton.Position = [26 373 100 22];
            app.Load_ImgButton.Text = 'Load_Img';

            % Create BinarizeButton
            app.BinarizeButton = uibutton(app.UIFigure, 'push');
            app.BinarizeButton.ButtonPushedFcn = createCallbackFcn(app, @BinarizeButtonPushed, true);
            app.BinarizeButton.Position = [26 335 100 22];
            app.BinarizeButton.Text = 'Binarize';

            % Create SegmentButton
            app.SegmentButton = uibutton(app.UIFigure, 'push');
            app.SegmentButton.ButtonPushedFcn = createCallbackFcn(app, @SegmentButtonPushed, true);
            app.SegmentButton.Position = [26 295 100 22];
            app.SegmentButton.Text = 'Segment';

            % Create SegmentMethodDropDownLabel
            app.SegmentMethodDropDownLabel = uilabel(app.UIFigure);
            app.SegmentMethodDropDownLabel.HorizontalAlignment = 'right';
            app.SegmentMethodDropDownLabel.Position = [140 295 97 22];
            app.SegmentMethodDropDownLabel.Text = 'Segment Method';

            % Create SegmentMethodDropDown
            app.SegmentMethodDropDown = uidropdown(app.UIFigure);
            app.SegmentMethodDropDown.Items = {'Two pass', 'BFS', 'Quadtree', 'Regional growth'};
            app.SegmentMethodDropDown.DropDownOpeningFcn = createCallbackFcn(app, @SegmentMethodDropDownOpening, true);
            app.SegmentMethodDropDown.ValueChangedFcn = createCallbackFcn(app, @SegmentMethodDropDownValueChanged, true);
            app.SegmentMethodDropDown.Position = [252 295 100 22];
            app.SegmentMethodDropDown.Value = 'Two pass';

            % Create LocalBinarizeButton
            app.LocalBinarizeButton = uibutton(app.UIFigure, 'push');
            app.LocalBinarizeButton.ButtonPushedFcn = createCallbackFcn(app, @LocalBinarizeButtonPushed, true);
            app.LocalBinarizeButton.Position = [145 20 100 22];
            app.LocalBinarizeButton.Text = 'Local Binarize';

            % Create AppendLabel
            app.AppendLabel = uilabel(app.UIFigure);
            app.AppendLabel.Position = [92 20 50 22];
            app.AppendLabel.Text = 'Append:';

            % Create Rotation90Button
            app.Rotation90Button = uibutton(app.UIFigure, 'push');
            app.Rotation90Button.ButtonPushedFcn = createCallbackFcn(app, @Rotation90ButtonPushed, true);
            app.Rotation90Button.Position = [25 258 100 22];
            app.Rotation90Button.Text = 'Rotation 90°';

            % Create Rotation35Button
            app.Rotation35Button = uibutton(app.UIFigure, 'push');
            app.Rotation35Button.ButtonPushedFcn = createCallbackFcn(app, @Rotation35ButtonPushed, true);
            app.Rotation35Button.Position = [145 258 100 22];
            app.Rotation35Button.Text = 'Rotation -35°';

            % Create EdgedetectionButton
            app.EdgedetectionButton = uibutton(app.UIFigure, 'push');
            app.EdgedetectionButton.ButtonPushedFcn = createCallbackFcn(app, @EdgedetectionButtonPushed, true);
            app.EdgedetectionButton.Position = [25 219 100 22];
            app.EdgedetectionButton.Text = 'Edge detection';

            % Create ThinButton
            app.ThinButton = uibutton(app.UIFigure, 'push');
            app.ThinButton.ButtonPushedFcn = createCallbackFcn(app, @ThinButtonPushed, true);
            app.ThinButton.Position = [26 181 100 22];
            app.ThinButton.Text = 'Thin';

            % Create arrangementButton
            app.arrangementButton = uibutton(app.UIFigure, 'push');
            app.arrangementButton.ButtonPushedFcn = createCallbackFcn(app, @arrangementButtonPushed, true);
            app.arrangementButton.Position = [25 143 100 22];
            app.arrangementButton.Text = 'arrangement';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Machine_Version_Project_exported

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