import csfml
import random, math

randomize()

type Particle* = ref object 
    velocity*: Vector2f
    lifetime*: Time 

type ParticleSsytem* = ref object 
    particles*: seq[Particle]
    vertices*: VertexArray
    lifeTime*: Time
    emitter*: Vector2f

method resetParticle(self: ParticleSsytem, index: int) =
    var angle = random(360.0) * PI / 180
    var speed = random(50.0) + 50

    self.particles[index].velocity = vec2(cos(angle) * speed, sin(angle) * speed)
    self.particles[index].lifetime = milliseconds(toU32(random(3000) + 3000))

    var randR = cast[uint8](random(255))
    var randG = cast[uint8](random(255))
    var randB = cast[uint8](random(255))
    
    self.vertices.getVertex(index).position = self.emitter
    self.vertices.getVertex(index).color.r = randR
    self.vertices.getVertex(index).color.g = randG
    self.vertices.getVertex(index).color.b = randB

method update*(self: ParticleSsytem, elapsed: Time) =
    for i in 0 .. <len(self.particles):
        var particle = self.particles[i]
        particle.lifetime = particle.lifetime - elapsed

        if particle.lifetime <= milliseconds(toU32(0)):
            resetParticle(self, i)

        self.vertices.getVertex(i).position = self.vertices.getVertex(i).position + particle.velocity * elapsed.asSeconds

        var ratio = particle.lifetime.asSeconds / self.lifeTime.asSeconds

        self.vertices.getVertex(i).color.a = cast[uint8](toInt(ratio * 255.0f))
        # self.vertices.getVertex(i).color = White

method draw*[T](self: ParticleSsytem, target: T, states: RenderStates) =
    # states.transform *= self.transform
    # states.texture = &self.tileset

    target.draw self.vertices, states

proc createParticle*(): Particle =     
    var angle = random(360.0) * PI / 180
    var speed = random(50.0) + 50

    return Particle(velocity: vec2(cos(angle) * speed, sin(angle) * speed), lifetime: milliseconds(toU32(random(3000) + 3000)))