import csfml
import particle_system

var 
    window = newRenderWindow(videoMode(1024, 512), "Particles")
    allParticles: seq[Particle]

for i in 1 .. 10000:
    allParticles.add(createParticle())

var
    particles = ParticleSsytem(particles: allParticles, vertices: newVertexArray(PrimitiveType.Points, 10000), lifeTime: seconds(6.0f), emitter: vec2(0.0f, 0.0f))
    clock = newClock()

while window.open:
    var event: Event 

    while window.pollEvent event:
        if event.kind == EventType.Closed:
            window.close()

    var mouse = mouse_getPosition window
    particles.emitter = mouse

    var elapsed = clock.restart()
    particles.update(elapsed)

    window.clear Black
    window.draw particles 
    window.display()

