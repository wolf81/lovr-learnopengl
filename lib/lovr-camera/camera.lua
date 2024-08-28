local PATH = (...):match('(.-)[^%.]+$') 

local Camera = {}

-- assert(type(jit) == 'table' and lovr.system.getOS() ~= 'Android', 'lovr-mouse cannot run on this platform')
local ffi = require 'ffi'
local C = ffi.os == 'Windows' and ffi.load('glfw3') or ffi.C

ffi.cdef [[
  enum {
    GLFW_CURSOR = 0x00033001,
    GLFW_CURSOR_NORMAL = 0x00034001,
    GLFW_CURSOR_HIDDEN = 0x00034002,
    GLFW_CURSOR_DISABLED = 0x00034003,
    GLFW_ARROW_CURSOR = 0x00036001,
    GLFW_IBEAM_CURSOR = 0x00036002,
    GLFW_CROSSHAIR_CURSOR = 0x00036003,
    GLFW_HAND_CURSOR = 0x00036004,
    GLFW_HRESIZE_CURSOR = 0x00036005,
    GLFW_VRESIZE_CURSOR = 0x00036006
  };

  typedef struct {
    int width;
    int height;
    unsigned char* pixels;
  } GLFWimage;

  typedef struct GLFWcursor GLFWcursor;
  typedef struct GLFWwindow GLFWwindow;
  typedef void(*GLFWmousebuttonfun)(GLFWwindow*, int, int, int);
  typedef void(*GLFWcursorposfun)(GLFWwindow*, double, double);
  typedef void(*GLFWscrollfun)(GLFWwindow*, double, double);

  GLFWwindow* os_get_glfw_window(void);
  void glfwGetInputMode(GLFWwindow* window, int mode);
  void glfwSetInputMode(GLFWwindow* window, int mode, int value);
  void glfwGetCursorPos(GLFWwindow* window, double* x, double* y);
  void glfwSetCursorPos(GLFWwindow* window, double x, double y);
  GLFWcursor* glfwCreateCursor(const GLFWimage* image, int xhot, int yhot);
  GLFWcursor* glfwCreateStandardCursor(int kind);
  void glfwSetCursor(GLFWwindow* window, GLFWcursor* cursor);
  int glfwGetMouseButton(GLFWwindow* window, int button);
  void glfwGetWindowSize(GLFWwindow* window, int* width, int* height);
  GLFWmousebuttonfun glfwSetMouseButtonCallback(GLFWwindow* window, GLFWmousebuttonfun callback);
  GLFWcursorposfun glfwSetCursorPosCallback(GLFWwindow* window, GLFWcursorposfun callback);
  GLFWcursorposfun glfwSetScrollCallback(GLFWwindow* window, GLFWscrollfun callback);
]]

local window = ffi.C.os_get_glfw_window()

local function getMouseScale()
    local x, _ = ffi.new('int[1]'), ffi.new('int[1]')
    C.glfwGetWindowSize(window, x, _)
    return lovr.system.getWindowWidth() / x[0]
end

local function getMousePosition()
    local x, y = ffi.new('double[1]'), ffi.new('double[1]')
    local scale = getMouseScale()
    C.glfwGetCursorPos(window, x, y)
    return x[0] * scale, y[0] * scale
end

local function setMouseRelativeMode(enable)
    C.glfwSetInputMode(window, C.GLFW_CURSOR, enable and C.GLFW_CURSOR_DISABLED or C.GLFW_CURSOR_NORMAL)
end

Camera.new = function(x, y, z)
    setMouseRelativeMode(true)

    local transform = Mat4()
    local position = Vec3(x or 0, y or 0, z or 0)
    local movespeed = 10
    local pitch = 0
    local yaw = 0

    local mouse = {}

    local fov = 45

    C.glfwSetScrollCallback(window, function(target, x, y)
        if not target == window then return end

        local fov_ = fov - y * getMouseScale()
        fov = math.min(math.max(fov_, 1.0), 45)
    end)

    local update = function(self, dt)
        local velocity = vec4()

        if lovr.system.isKeyDown('w', 'up') then
            velocity.z = -1
        elseif lovr.system.isKeyDown('s', 'down') then
            velocity.z = 1
        end

        if lovr.system.isKeyDown('a', 'left') then
            velocity.x = -1
        elseif lovr.system.isKeyDown('d', 'right') then
            velocity.x = 1
        end

        if #velocity > 0 then
            velocity:normalize()
            velocity:mul(movespeed * dt)
            position:add(transform:mul(velocity).xyz)
        end

        transform:identity()
        transform:translate(0, 0, 0)
        transform:translate(position)
        transform:rotate(yaw, 0, 1, 0)
        transform:rotate(pitch, 1, 0, 0)

        local x, y = getMousePosition()

        if not next(mouse) then
            mouse.x = x
            mouse.y = y
        end

        local dx = x - mouse.x
        local dy = y - mouse.y

        pitch = pitch - dy * .002
        yaw = yaw - dx * .004            

        mouse.x = x
        mouse.y = y
    end

    local draw = function(self, pass, fn)
        pass:push()

        local perspective = Mat4():perspective(math.rad(fov), 800 / 600, 0.1, 0.0)
        pass:setProjection(1, perspective)

        pass:setViewPose(1, transform)

        fn()

        pass:pop()
    end

    local setPosition = function(self, x, y, z)
        position = Vec3(x, y, z)
    end

    local getPosition = function(self)
        return position
    end

    local getDirection = function(self)
        return Quat(transform):direction()
    end

    local deinit = function(self)
        setMouseRelativeMode(false)        
    end

    return setmetatable({
        -- methods
        deinit          = deinit,
        draw            = draw,        
        update          = update,
        setPosition     = setPosition,
        getPosition     = getPosition,
        getDirection    = getDirection,
    }, Camera)
end

return setmetatable(Camera, {
    __call = function(_, ...) return Camera.new(...) end,
})
