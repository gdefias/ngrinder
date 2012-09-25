/*
 * Copyright (C) 2012 - 2012 NHN Corporation
 * All rights reserved.
 *
 * This file is part of The nGrinder software distribution. Refer to
 * the file LICENSE which is part of The nGrinder distribution for
 * licensing details. The nGrinder distribution is available on the
 * Internet at http://nhnopensource.org/ngrinder
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package org.ngrinder.monitor.controller;

import static org.ngrinder.common.util.Preconditions.checkNotNull;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import org.ngrinder.monitor.controller.domain.MonitorAgentInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * Used to manage the monitoring job.
 *
 * @author Mavlarn
 * @since 3.0
 */
public class MonitorExecuteManager {
	
	private static final Logger LOG = LoggerFactory.getLogger(MonitorExecuteManager.class);
	private long firstTime = 1;
	private long interval = 1;

	private Map<String, ScheduledExecutorService> schedulerMap = new HashMap<String, ScheduledExecutorService>();
	private Map<String, MonitorExecuteWorker> monitorWorkerMap = new HashMap<String, MonitorExecuteWorker>();
	
	private static MonitorExecuteManager instance = new MonitorExecuteManager();
	
	//instance class, avoid creating object
	private MonitorExecuteManager() {}
	
	public static MonitorExecuteManager getInstance() {
		return instance;
	}
	
	/**
	 * add a new monitoring job.
	 * If there is already a job monitoring on that server, just increase the counter.
	 * @param key
	 * @param agent
	 */
	public void addAgentMonitor(String key, MonitorAgentInfo agent) {
		MonitorExecuteWorker worker = monitorWorkerMap.get(agent.getIp());
		if (worker == null) {
			worker = new MonitorExecuteWorker(key, agent);
			ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
			scheduler.scheduleAtFixedRate(worker, firstTime, interval, TimeUnit.SECONDS);
			monitorWorkerMap.put(agent.getIp(), worker);
			schedulerMap.put(agent.getIp(), scheduler);
			LOG.debug("Add monitoring worker for {} successfully.", agent.getIp());
		} else {
			worker.increaseCounter();
			LOG.debug("Monitoring worker for {} already exist.", agent.getIp());
		}
	}
	
	/**
	 * remove a monitoring job if there is only one test monitoring on this server.
	 * @param agent
	 */
	public void removeAgentMonitor(String agentIP) {
		MonitorExecuteWorker worker = checkNotNull(monitorWorkerMap.get(agentIP));
		worker.decreaseCounter();
		if (worker.getCounter() <= 0) {
			schedulerMap.get(agentIP).shutdown();
			worker.close();
			monitorWorkerMap.remove(agentIP);
		}
	}

}
