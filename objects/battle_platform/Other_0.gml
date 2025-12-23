var destroy;
if auto_destroy
{
    destroy = 0
    if (y < 0)
        destroy = 1
    if (y > 480)
        destroy = 1
    if (x < 0)
        destroy = 1
    if (y > 640)
        destroy = 1
    if destroy
        instance_destroy()
}