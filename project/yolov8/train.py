from ultralytics import YOLO

#load model
model = YOLO('yolov8m.pt')

#use the model
results = model.train(
    data="config.yaml", 
    epochs=180, 
    imgsz=640, 
    batch=4,
    lr0= 0.00858,
    lrf= 0.00789,
    momentum= 0.95688,
    weight_decay= 0.00059,
    warmup_epochs= 4.0684,
    warmup_momentum= 0.95,
    box= 7.5,
    cls= 0.49114,
    dfl= 1.36702,
    hsv_h= 0.015,
    hsv_s= 0.87925,
    hsv_v= 0.39283,
    degrees= 0.0,
    translate= 0.1054,
    scale= 0.46501,
    shear= 0.0,
    perspective= 0.0,
    flipud= 0.0,
    fliplr= 0.52369,
    mosaic= 1.0,
    mixup= 0.0,
    copy_paste= 0.0,
    ) 


# original version
# results = model.train(
#     data="config.yaml", 
#     epochs=180, 
#     imgsz=640, 
#     batch=4,
#     lr0= 0.00708,
#     lrf= 0.01054,
#     momentum= 0.8772,
#     weight_decay= 0.00048,
#     warmup_epochs= 2.58139,
#     warmup_momentum= 0.52363,
#     box= 7.61302,
#     cls= 0.44118,
#     dfl= 1.32063,
#     hsv_h= 0.01536,
#     hsv_s= 0.7071,
#     hsv_v= 0.41765,
#     degrees= 0.0,
#     translate= 0.09215,
#     scale= 0.47412,
#     shear= 0.0,
#     perspective= 0.0,
#     flipud= 0.0,
#     fliplr= 0.52344,
#     mosaic= 0.87597,
#     mixup= 0.0,
#     copy_paste= 0.0,
#     ) 